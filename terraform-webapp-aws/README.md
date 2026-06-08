# Terraform Web App AWS

Project nay tao mot web app don gian tren AWS bang Terraform:

- VPC custom
- 2 public subnets va 2 private subnets
- Internet Gateway va public Route Table
- EC2 public subnet chay Nginx, serve `app/index.html` va `app/style.css`
- RDS MySQL private subnet
- S3 bucket static assets voi ten unique bang random suffix
- Security Group toi thieu: HTTP/SSH cho EC2, MySQL chi tu EC2 SG
- Ho tro S3 remote state va DynamoDB locking qua `backend.tf.example`

## Cau truc thu muc

```text
.
|-- provider.tf
|-- backend.tf.example
|-- variables.tf
|-- terraform.tfvars.example
|-- main.tf
|-- outputs.tf
|-- modules/
|   |-- vpc/
|   |-- security-group/
|   |-- ec2/
|   |-- rds/
|   `-- s3/
|-- app/
|   |-- index.html
|   `-- style.css
|-- scripts/
|   |-- deploy.sh
|   `-- destroy.sh
|-- evidence/
|   |-- evidence.md
|   `-- screenshots/
|-- README.md
`-- .gitignore
```

## Yeu cau truoc khi chay

1. Cai Terraform >= 1.5.
2. Cai va cau hinh AWS CLI.
3. Tai khoan AWS co quyen tao VPC, EC2, RDS, S3, Security Group.
4. Nen dung AWS Free Tier va destroy sau khi demo de tranh phi.

Kiem tra AWS credentials:

```bash
aws sts get-caller-identity
```

## Cau hinh bien

Tao file cau hinh tu file mau:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Sua cac gia tri can thiet trong `terraform.tfvars`:

```hcl
project_name = "terraform-webapp"
aws_region   = "us-east-1"
ssh_cidr     = "YOUR_PUBLIC_IP/32"
db_name      = "webappdb"
db_username  = "adminuser"
db_password  = "YourStrongPassword123!"
```

De demo nhanh co the de `ssh_cidr = "0.0.0.0/0"`, nhung khi nop bai nen dung IP cua ban voi `/32`.

Khuyen nghi khong ghi password that vao file. Co the xoa `db_password` trong `terraform.tfvars` va truyen bang bien moi truong:

```bash
export TF_VAR_db_password='YourStrongPassword123!'
```

Tren PowerShell:

```powershell
$env:TF_VAR_db_password="YourStrongPassword123!"
```

Neu muon SSH vao EC2, tao EC2 key pair tren AWS roi them:

```hcl
key_name = "ten-key-pair-cua-ban"
```

## Remote state S3 backend va DynamoDB locking

Project chi tao `backend.tf.example`, khong tao `backend.tf` that vi S3 bucket backend va DynamoDB lock table phai co truoc khi `terraform init`.

Tao S3 bucket backend va DynamoDB table rieng, vi du:

```bash
aws s3api create-bucket --bucket your-terraform-state-bucket-name --region us-east-1
aws s3api put-bucket-versioning --bucket your-terraform-state-bucket-name --versioning-configuration Status=Enabled
aws dynamodb create-table \
  --table-name your-terraform-lock-table-name \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region us-east-1
```

Sau do copy file backend mau:

```bash
cp backend.tf.example backend.tf
```

Sua `bucket`, `key`, `region`, `dynamodb_table` trong `backend.tf`, roi chay:

```bash
terraform init
```

Neu chua can remote state khi demo local, co the khong tao `backend.tf`.

## Deploy

Chay bang script:

```bash
chmod +x scripts/deploy.sh scripts/destroy.sh
./scripts/deploy.sh
```

Hoac chay tung lenh:

```bash
terraform init
terraform fmt -recursive
terraform validate
terraform plan -out=tfplan
terraform apply tfplan
```

Sau khi apply xong, Terraform se in ra:

- `ec2_public_ip`
- `web_url`
- `rds_endpoint`
- `s3_bucket_name`

Mo `web_url` tren trinh duyet de xem web app.

## Destroy tranh ton phi

Sau khi chup evidence va demo xong, xoa resource:

```bash
./scripts/destroy.sh
```

Hoac:

```bash
terraform destroy
```

## Evidence nop mentor

Dung file `evidence/evidence.md` lam checklist. Luu anh vao `evidence/screenshots/` theo ten goi y trong file.

## Ghi chu chi phi

- EC2 mac dinh `t2.micro`, phu hop Free Tier o nhieu tai khoan/region.
- RDS mac dinh `db.t3.micro`, storage 20 GB, single-AZ, khong backup de giam chi phi demo.
- S3 bucket private, versioning suspended.
- Khong tao NAT Gateway vi NAT Gateway co the ton phi; RDS private khong can Internet route cho yeu cau demo nay.
