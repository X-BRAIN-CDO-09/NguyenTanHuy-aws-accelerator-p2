terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "day_a_demo" {
  bucket = var.bucket_name

  tags = {
    Name        = "w8-day-a-demo"
    Owner       = "Huy"
    Week        = "W8"
    Day         = "Day-A"
    Environment = "Learning"
  }
}