variable "project_name" {
  description = "Ten project dung de dat tag va ten resource."
  type        = string
  default     = "terraform-webapp"
}

variable "aws_region" {
  description = "AWS region deploy ha tang."
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block cho VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks cho 2 public subnets."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks cho 2 private subnets."
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "ssh_cidr" {
  description = "CIDR duoc phep SSH vao EC2. Dung IP cua ban /32, hoac 0.0.0.0/0 de demo."
  type        = string
  default     = "0.0.0.0/0"
}

variable "instance_type" {
  description = "EC2 instance type free tier."
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Ten EC2 key pair da ton tai tren AWS. De null neu khong can SSH bang key."
  type        = string
  default     = null
}

variable "db_name" {
  description = "Ten database MySQL ban dau."
  type        = string
  default     = "webappdb"
}

variable "db_username" {
  description = "Username master cua RDS MySQL."
  type        = string
  default     = "adminuser"
}

variable "db_password" {
  description = "Password master cua RDS MySQL. Khong hardcode trong code, truyen qua tfvars hoac bien moi truong TF_VAR_db_password."
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  description = "RDS instance class tiet kiem chi phi."
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "Dung luong RDS tinh bang GB."
  type        = number
  default     = 20
}
