output "alb_dns_name" {
  value = aws_lb.app.dns_name
}

output "alb_url" {
  value = "http://${aws_lb.app.dns_name}"
}

output "ec2_public_ip" {
  value = aws_instance.minikube.public_ip
}

output "ssh_command" {
  value = "ssh -i .generated/minikube-key ubuntu@${aws_instance.minikube.public_ip}"
}

output "private_key_pem" {
  value     = tls_private_key.minikube.private_key_pem
  sensitive = true
}
