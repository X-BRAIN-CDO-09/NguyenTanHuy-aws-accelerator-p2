output "ec2_public_ip" {
  description = "Public IP cua EC2 web server."
  value       = module.ec2.public_ip
}

output "web_url" {
  description = "URL truy cap web app."
  value       = "http://${module.ec2.public_dns}"
}

output "rds_endpoint" {
  description = "Endpoint cua RDS MySQL."
  value       = module.rds.endpoint
}

output "s3_bucket_name" {
  description = "Ten S3 bucket static assets."
  value       = module.s3.bucket_name
}
