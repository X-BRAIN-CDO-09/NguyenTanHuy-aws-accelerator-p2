output "bucket_name" {
  description = "Created S3 bucket name"
  value       = aws_s3_bucket.day_a_demo.bucket
}

output "bucket_arn" {
  description = "Created S3 bucket ARN"
  value       = aws_s3_bucket.day_a_demo.arn
}