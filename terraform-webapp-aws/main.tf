data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source = "./modules/vpc"

  project_name         = var.project_name
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = slice(data.aws_availability_zones.available.names, 0, 2)
}

module "security_group" {
  source = "./modules/security-group"

  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id
  ssh_cidr     = var.ssh_cidr
}

module "s3" {
  source = "./modules/s3"

  project_name = var.project_name
  static_assets = {
    "index.html" = {
      content_type = "text/html"
      content      = file("${path.module}/app/index.html")
    }
    "style.css" = {
      content_type = "text/css"
      content      = file("${path.module}/app/style.css")
    }
  }
}

module "ec2" {
  source = "./modules/ec2"

  project_name      = var.project_name
  subnet_id         = module.vpc.public_subnet_ids[0]
  security_group_id = module.security_group.ec2_security_group_id
  instance_type     = var.instance_type
  key_name          = var.key_name
  index_html        = file("${path.module}/app/index.html")
  style_css         = file("${path.module}/app/style.css")
  s3_bucket_name    = module.s3.bucket_name
}

module "rds" {
  source = "./modules/rds"

  project_name          = var.project_name
  private_subnet_ids    = module.vpc.private_subnet_ids
  rds_security_group_id = module.security_group.rds_security_group_id
  db_name               = var.db_name
  db_username           = var.db_username
  db_password           = var.db_password
  db_instance_class     = var.db_instance_class
  db_allocated_storage  = var.db_allocated_storage
}
