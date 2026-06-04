variable "project_name" {
  type    = string
  default = "k8s-aws-1click"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "instance_type" {
  type    = string
  default = "t3.small"
}

variable "node_port" {
  type    = number
  default = 30080
}

variable "ssh_allowed_cidr" {
  type    = string
  default = "0.0.0.0/0"
}
