output "wordpress_public_ip" {
  description = "Public IP address of the WordPress EC2 instance"
  value       = aws_instance.wordpress.public_ip
}

output "wordpress_url" {
  description = "URL of the WordPress site"
  value       = "http://${aws_instance.wordpress.public_ip}"
}