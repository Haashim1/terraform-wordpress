terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Find the latest Ubuntu 22.04 AMI
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

# Find the existing default VPC
data "aws_vpc" "default" {
  default = true
}

# Create an Internet Gateway
resource "aws_internet_gateway" "wordpress" {
  vpc_id = data.aws_vpc.default.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

# Create a subnet
resource "aws_subnet" "wordpress" {
  vpc_id     = data.aws_vpc.default.id
  cidr_block = "172.31.0.0/20"

  tags = {
    Name = "${var.project_name}-subnet"
  }
}

# Create a route table
resource "aws_route_table" "wordpress" {
  vpc_id = data.aws_vpc.default.id

  tags = {
    Name = "${var.project_name}-route-table"
  }
}

# Send internet traffic through the Internet Gateway
resource "aws_route" "wordpress_internet" {
  route_table_id         = aws_route_table.wordpress.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.wordpress.id
}

# Associate the subnet with the route table
resource "aws_route_table_association" "wordpress" {
  subnet_id      = aws_subnet.wordpress.id
  route_table_id = aws_route_table.wordpress.id
}

# Create a security group
resource "aws_security_group" "wordpress" {
  name        = "${var.project_name}-sg"
  description = "Security group for WordPress"
  vpc_id      = data.aws_vpc.default.id
}

# Allow HTTP traffic
resource "aws_vpc_security_group_ingress_rule" "wordpress_http" {
  security_group_id = aws_security_group.wordpress.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

# Allow outbound traffic
resource "aws_vpc_security_group_egress_rule" "wordpress_all_outbound" {
  security_group_id = aws_security_group.wordpress.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# Create the WordPress EC2 instance
resource "aws_instance" "wordpress" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  subnet_id = aws_subnet.wordpress.id

  associate_public_ip_address = true

  vpc_security_group_ids = [
    aws_security_group.wordpress.id
  ]

  user_data                   = file("${path.module}/user-data.sh")
  user_data_replace_on_change = true

  tags = {
    Name = var.project_name
  }
}

