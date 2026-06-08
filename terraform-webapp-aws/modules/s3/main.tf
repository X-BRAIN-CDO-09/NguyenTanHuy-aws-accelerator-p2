resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "this" {
  bucket        = "${var.project_name}-static-${random_id.suffix.hex}"
  force_destroy = true

  tags = {
    Name = "${var.project_name}-static-assets"
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = "Suspended"
  }
}

resource "aws_s3_object" "static_assets" {
  for_each = var.static_assets

  bucket       = aws_s3_bucket.this.id
  key          = each.key
  content      = each.value.content
  content_type = each.value.content_type
  etag         = md5(each.value.content)
}
