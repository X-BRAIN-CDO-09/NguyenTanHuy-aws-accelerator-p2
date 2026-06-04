resource "tls_private_key" "minikube" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "minikube" {
  key_name   = "${var.project_name}-key"
  public_key = tls_private_key.minikube.public_key_openssh

  tags = {
    Project   = var.project_name
    ManagedBy = "terraform"
  }
}

resource "aws_instance" "minikube" {
  ami                         = data.aws_ami.ubuntu_2204.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.minikube.key_name
  subnet_id                   = data.aws_subnets.default.ids[0]
  vpc_security_group_ids      = [aws_security_group.ec2.id]
  associate_public_ip_address = true
  user_data                   = file("${path.module}/user_data.sh")

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-minikube"
  })
}
