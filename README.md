# Deploy WordPress Using Terraform

I built this project to practice using Terraform to deploy and configure a WordPress server on AWS.

## What I Built

Terraform creates:

* EC2 instance running Ubuntu
* Security group allowing HTTP traffic
* Subnet and route table
* Internet Gateway
* Public IP address

The EC2 instance uses a Bash `user-data.sh` script to automatically install:

* Apache
* PHP
* MySQL
* WordPress

## Project Structure

```text
terraform-wordpress/
├── main.tf
├── variables.tf
├── outputs.tf
├── user-data.sh
├── screenshots/
├── .gitignore
└── README.md
```

## How It Works

Terraform provisions the AWS infrastructure and launches the EC2 instance.

When the instance starts, `user-data.sh` installs and configures the software needed to run WordPress.

Terraform outputs the public IP address and WordPress URL.

## Deploy

```bash
terraform init
terraform plan
terraform apply
```

After deployment:

```bash
terraform output wordpress_url
```

Open the URL in a browser to complete the WordPress setup.

## Validation

I verified the deployment by accessing the WordPress website and running:

```bash
terraform plan
```

Terraform confirmed:

```text
No changes. Your infrastructure matches the configuration.
```

## Screenshot

<img width="1440" height="900" alt="wordpress" src="https://github.com/user-attachments/assets/9835ae79-ab45-4675-96ba-b6df9b24d68f" />


## Cleanup

After testing, I removed the AWS resources with:

```bash
terraform destroy
```

## What I Learned

This project gave me practical experience with:

* Terraform
* AWS EC2
* AWS networking
* Security groups
* Terraform variables and outputs
* Bash user data
* Automating server configuration
* Deploying WordPress on AWS
* Git and GitHub

