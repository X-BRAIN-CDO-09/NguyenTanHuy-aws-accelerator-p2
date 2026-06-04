# K8s on AWS - Terraform 1-Click

Project này dựng một EC2 Ubuntu trên AWS, cài Docker + kubectl + minikube, deploy app HTML/CSS vào Kubernetes/minikube, rồi public app ra Internet qua AWS Application Load Balancer thật.

Toàn bộ chạy từ repo sạch bằng một lệnh:

```bash
make up
```

## Kiến Trúc

```text
Internet
  -> AWS ALB :80
  -> Target Group
  -> EC2 NodePort :30080
  -> Minikube Service NodePort
  -> Pod nginx
  -> HTML/CSS app
```

Terraform chỉ dùng đúng 2 provider chính:

- `tls`
- `aws`

Không dùng Kubernetes provider, không dùng null provider để deploy app.

## App Không Cài Thẳng Lên EC2

EC2 chỉ đóng vai trò host chạy Docker và minikube. App không được cài bằng nginx trực tiếp trên EC2, không có systemd service riêng cho app.

Luồng deploy app nằm trong `terraform/user_data.sh`:

- Cài Docker, kubectl, minikube.
- Start minikube bằng Docker driver.
- Tạo Kubernetes manifest.
- `kubectl apply` Namespace, ConfigMap, Deployment, Service.
- Pod chạy image `nginx:alpine`.
- HTML/CSS được mount từ ConfigMap vào `/usr/share/nginx/html`.

Kiểm tra app thật sự chạy trong Kubernetes:

```bash
kubectl get pods -n app
kubectl get svc -n app
```

## ALB Nối Vào NodePort

Kubernetes Service dùng `NodePort` cố định `30080`. Minikube được start với port mapping:

```bash
minikube start --driver=docker --container-runtime=docker --cpus=2 --memory=1800mb --ports=30080:30080
```

AWS ALB có listener HTTP port `80`. Target Group trỏ đến EC2 instance port `30080`.

Luồng request:

```text
Browser -> ALB:80 -> EC2:30080 -> Minikube NodePort -> Service -> nginx Pod
```

Security Group:

- ALB SG cho phép Internet vào port `80`.
- EC2 SG cho phép SSH port `22` từ `ssh_allowed_cidr`.
- EC2 SG chỉ cho phép port `30080` từ ALB SG.
- EC2 outbound mở để tải package và image.

## Provider Wiring

Provider `tls` tạo SSH key:

```hcl
resource "tls_private_key" "minikube" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
```

Provider `aws` dùng public key từ TLS để tạo EC2 KeyPair:

```hcl
resource "aws_key_pair" "minikube" {
  public_key = tls_private_key.minikube.public_key_openssh
}
```

Đây là wiring thật giữa 2 provider: output của `tls` trở thành input của `aws`. Private key được output dạng sensitive, sau đó script ghi ra `.generated/minikube-key` để SSH kiểm tra EC2. File này bị ignore bởi Git.

Provider `aws` quản lý:

- EC2 Ubuntu 22.04
- Key Pair
- Security Groups
- Application Load Balancer
- Target Group
- Listener
- Target Group Attachment

## Cách Chạy

Kiểm tra AWS credentials:

```bash
aws sts get-caller-identity
```

Chạy 1-click:

```bash
make up
```

Hoặc chạy trực tiếp script:

```bash
bash scripts/up.sh
```

Region mặc định là `us-east-1`, instance mặc định là `t3.small`. Có thể override bằng Terraform env var:

```bash
TF_VAR_region=ap-southeast-1 make up
```

## Kiểm Tra

Lấy URL:

```bash
terraform -chdir=terraform output alb_url
```

Mở URL trên browser. Bạn sẽ thấy trang HTML/CSS được serve từ nginx Pod trong Kubernetes.

SSH vào EC2:

```bash
ssh -i .generated/minikube-key ubuntu@<ec2_public_ip>
```

Lấy public IP:

```bash
terraform -chdir=terraform output -raw ec2_public_ip
```

Kiểm tra Kubernetes:

```bash
kubectl get pods -n app
kubectl get svc -n app
curl localhost:30080
```

Service `html-service` phải là `NodePort` với `nodePort: 30080`.

## Destroy

Xoá sạch hạ tầng AWS và key local generated:

```bash
make destroy
```

Hoặc:

```bash
bash scripts/destroy.sh
```

## Acceptance Checklist

- [x] 1 lệnh từ repo sạch: `make up`
- [x] App chạy trong K8s/minikube, không cài trực tiếp lên EC2
- [x] App truy cập qua AWS ALB thật
- [x] Có >=2 provider: `aws` + `tls`
- [x] Provider wiring rõ ràng: TLS public key được AWS KeyPair sử dụng
- [x] Reproducible, destroy sạch và dựng lại được
- [x] Không hard-code AWS credentials
- [x] Không commit `.generated`, private key, Terraform state
