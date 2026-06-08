variable "project_name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "security_group_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "key_name" {
  type    = string
  default = null
}

variable "index_html" {
  type = string
}

variable "style_css" {
  type = string
}

variable "s3_bucket_name" {
  type = string
}
