variable "aws_region" {
  description = "AWS region used for W8 Day A Terraform practice"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Unique S3 bucket name for Terraform Day A practice"
  type        = string
  default     = "huy-w8-day-a-terraform-demo-46205"
}