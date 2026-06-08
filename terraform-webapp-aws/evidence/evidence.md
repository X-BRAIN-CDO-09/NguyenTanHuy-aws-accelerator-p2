# Evidence - Terraform Web App AWS

Dung file nay de dan anh chup man hinh va ghi chu khi bao cao mentor.

## 1. Terraform init / validate / plan

- Anh chup terminal chay `terraform init`
- Anh chup terminal chay `terraform validate`
- Anh chup terminal chay `terraform plan`

![Terraform init validate plan](./screenshots/01-terraform-init-validate-plan.png)

## 2. Terraform apply thanh cong

- Anh chup terminal hien output: `ec2_public_ip`, `web_url`, `rds_endpoint`, `s3_bucket_name`

![Terraform apply output](./screenshots/02-terraform-apply-output.png)
![alt text](image-8.png)
## 3. VPC va subnet

- Anh chup AWS Console: VPC custom
- 2 public subnets
- 2 private subnets
- Internet Gateway
- Public Route Table co route `0.0.0.0/0` tro den IGW

![VPC subnets](./screenshots/03-vpc-subnets.png)
![Public route table](./screenshots/04-public-route-table.png)
![alt text](image-1.png)
![alt text](image.png)
![alt text](image-2.png)
## 4. Security Groups

- EC2 SG mo HTTP 80 tu Internet
- EC2 SG mo SSH 22 theo `ssh_cidr`
- RDS SG chi mo MySQL 3306 tu EC2 SG
![alt text](image-4.png)
![EC2 security group](./screenshots/05-ec2-security-group.png)
![RDS security group](./screenshots/06-rds-security-group.png)

## 5. EC2 web server

- Anh chup EC2 instance running
- Anh chup trinh duyet mo `web_url`
![alt text](image-3.png)
![EC2 running](./screenshots/07-ec2-running.png)
![Web app](./screenshots/08-web-app.png)

## 6. RDS MySQL private
![alt text](image-5.png)
- Anh chup RDS instance available
- Anh chup RDS khong public accessible

![RDS instance](./screenshots/09-rds-instance.png)

## 7. S3 static assets bucket
![alt text](image-6.png)
- Anh chup S3 bucket duoc tao voi suffix unique

![S3 bucket](./screenshots/10-s3-bucket.png)
![alt text](image-7.png)
## 8. Destroy

- Anh chup terminal chay `terraform destroy` thanh cong de chung minh da don resource tranh ton phi

![Terraform destroy](./screenshots/11-terraform-destroy.png)
![alt text](image-9.png)