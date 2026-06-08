# Giải Thích Chi Tiết Project

File này giải thích từng file trong project dùng để làm gì, và khi chạy lệnh thì chương trình bắt đầu từ đâu trước.

## Tổng Quan Project

Mục tiêu của project là dựng một app HTML/CSS chạy trong Kubernetes/minikube trên EC2, sau đó expose ra Internet bằng AWS Application Load Balancer thật.

Project dùng đúng 2 Terraform provider chính:

- `aws`: tạo hạ tầng AWS như EC2, Security Group, ALB, Target Group, Listener.
- `tls`: tạo SSH key pair bằng Terraform, sau đó public key được đưa vào AWS Key Pair.

Project không dùng Kubernetes provider. Việc deploy app vào Kubernetes được thực hiện trong EC2 thông qua `user_data.sh`.

## Cấu Trúc Thư Mục

```text
k8s-aws-terraform-1click/
├── README.md
├── PROJECT_EXPLAINED.md
├── .gitignore
├── Makefile
├── app/
│   ├── index.html
│   ├── style.css
│   └── Dockerfile
├── terraform/
│   ├── versions.tf
│   ├── providers.tf
│   ├── variables.tf
│   ├── main.tf
│   ├── outputs.tf
│   ├── aws_ec2.tf
│   ├── aws_alb.tf
│   ├── aws_security_group.tf
│   └── user_data.sh
├── scripts/
│   ├── up.sh
│   └── destroy.sh
└── evidence/
    └── .gitkeep
```

## Khi Chạy `make up` Thì Bắt Đầu Từ File Nào?

Khi bạn chạy:

```bash
make up
```

Thứ tự chạy là:

```text
Makefile
  -> scripts/up.sh
     -> terraform init
     -> terraform apply
        -> terraform/versions.tf
        -> terraform/providers.tf
        -> terraform/variables.tf
        -> terraform/main.tf
        -> terraform/aws_security_group.tf
        -> terraform/aws_ec2.tf
        -> terraform/aws_alb.tf
        -> terraform/outputs.tf
     -> EC2 chạy terraform/user_data.sh
        -> cài Docker, kubectl, minikube
        -> start minikube
        -> tạo Kubernetes manifest
        -> deploy nginx Pod + Service NodePort
     -> scripts/up.sh lấy output private_key_pem
     -> scripts/up.sh ghi key vào .generated/minikube-key
     -> scripts/up.sh SSH vào EC2 để chờ app sẵn sàng
     -> in ra ALB URL
```

Nói ngắn gọn: lệnh đầu tiên đi vào `Makefile`, sau đó `Makefile` gọi `scripts/up.sh`. Terraform tạo AWS infrastructure, còn EC2 tự chạy `user_data.sh` để cài minikube và deploy app.

## Khi Chạy `make destroy` Thì Bắt Đầu Từ File Nào?

Khi bạn chạy:

```bash
make destroy
```

Thứ tự chạy là:

```text
Makefile
  -> scripts/destroy.sh
     -> terraform destroy -auto-approve
     -> xoá thư mục .generated
```

Terraform sẽ xoá các tài nguyên AWS đã tạo: EC2, Key Pair, Security Group, ALB, Target Group, Listener và Target Group Attachment.

## Giải Thích Từng File Root

### `README.md`

Đây là file hướng dẫn chính của project.

File này giải thích:

- Bài toán cần làm.
- Kiến trúc tổng thể.
- Vì sao app chạy trong Kubernetes chứ không cài trực tiếp lên EC2.
- Vì sao dùng 2 provider `aws` và `tls`.
- Cách chạy `make up`.
- Cách kiểm tra ALB URL, Pod, Service.
- Cách destroy bằng `make destroy`.
- Acceptance checklist.

Khi nộp bài hoặc demo, đây là file người chấm thường đọc đầu tiên.

### `PROJECT_EXPLAINED.md`

Đây là file bạn đang đọc.

File này giải thích chi tiết từng file code trong project và thứ tự chạy của project. Nó hữu ích khi bạn cần thuyết trình, bảo vệ bài, hoặc giải thích cho mentor biết từng file có vai trò gì.

### `.gitignore`

File này quy định những file không được commit lên Git.

Các file bị ignore gồm:

- `.terraform/`: thư mục plugin/cache của Terraform.
- `*.tfstate`, `*.tfstate.*`: Terraform state, có thể chứa thông tin nhạy cảm.
- `.terraform.lock.hcl`: lock file provider hiện đang được ignore theo yêu cầu bài.
- `.generated/`: nơi script ghi private key SSH.
- `*.pem`, `*.key`: private key hoặc file nhạy cảm.
- `*.tfvars`: file biến Terraform, có thể chứa cấu hình riêng.

Mục tiêu là không commit credential, private key, state hoặc file generated.

### `Makefile`

File này tạo lệnh ngắn cho người dùng.

Nội dung chính:

```makefile
up:
	bash scripts/up.sh

destroy:
	bash scripts/destroy.sh
```

Ý nghĩa:

- `make up`: gọi script `scripts/up.sh`.
- `make destroy`: gọi script `scripts/destroy.sh`.

Người dùng không cần nhớ nhiều câu lệnh Terraform dài, chỉ cần dùng `make up` và `make destroy`.

## Giải Thích Thư Mục `app/`

### `app/index.html`

Đây là file HTML mẫu của app.

Nó mô tả trang web đơn giản hiển thị thông tin project như:

- App chạy trong Kubernetes.
- Traffic đi qua AWS ALB.
- Provider là `aws + tls`.

Trong thiết kế hiện tại, nội dung HTML thật sự được embed trực tiếp vào `terraform/user_data.sh` để EC2 tự tạo Kubernetes ConfigMap. File `app/index.html` vẫn được giữ để người đọc thấy source app HTML gốc.

### `app/style.css`

Đây là file CSS mẫu của app.

Nó định nghĩa giao diện trang HTML: layout, font, màu nền, card, responsive mobile.

Tương tự `index.html`, CSS thật sự được embed vào `user_data.sh` để tạo ConfigMap trong Kubernetes.

### `app/Dockerfile`

File này mô tả cách build app thành image nginx static nếu muốn build image riêng.

Nội dung:

```dockerfile
FROM nginx:1.27-alpine

COPY index.html /usr/share/nginx/html/index.html
COPY style.css /usr/share/nginx/html/style.css
```

Trong flow hiện tại, project không bắt buộc build Docker image riêng. Kubernetes Deployment dùng image `nginx:alpine`, còn HTML/CSS được mount bằng ConfigMap. File Dockerfile được giữ như một phương án tham khảo nếu sau này muốn build image custom.

## Giải Thích Thư Mục `terraform/`

### `terraform/versions.tf`

File này khai báo version Terraform và provider cần dùng.

Nội dung chính:

- Terraform version `>= 1.5.0`.
- Provider `aws` version `~> 5.0`.
- Provider `tls` version `~> 4.0`.

Đây là nơi chứng minh project dùng đúng 2 provider chính: `aws` và `tls`.

### `terraform/providers.tf`

File này cấu hình provider.

Nội dung chính:

```hcl
provider "aws" {
  region = var.region
}

provider "tls" {}
```

Ý nghĩa:

- AWS provider dùng biến `var.region` để biết sẽ tạo hạ tầng ở region nào.
- TLS provider không cần cấu hình thêm, dùng để sinh SSH key.

### `terraform/variables.tf`

File này khai báo các biến đầu vào của Terraform.

Các biến chính:

- `project_name`: tiền tố đặt tên resource, mặc định `k8s-aws-1click`.
- `region`: AWS region, mặc định `us-east-1`.
- `instance_type`: loại EC2, mặc định `t3.small`.
- `node_port`: NodePort của Kubernetes Service, mặc định `30080`.
- `ssh_allowed_cidr`: CIDR được phép SSH vào EC2, mặc định `0.0.0.0/0`.

Nếu muốn đổi region khi chạy:

```bash
TF_VAR_region=ap-southeast-1 make up
```

### `terraform/main.tf`

File này chứa phần dữ liệu dùng chung.

Nó khai báo:

- `local.common_tags`: tag chung cho resource AWS.
- `data "aws_vpc" "default"`: lấy default VPC.
- `data "aws_subnets" "default"`: lấy danh sách subnet trong default VPC.
- `data "aws_ami" "ubuntu_2204"`: tự tìm AMI Ubuntu 22.04 mới nhất.

Nhờ `data "aws_ami"`, project không hard-code AMI ID. Khi chạy ở region khác, Terraform tự lookup AMI phù hợp.

### `terraform/aws_security_group.tf`

File này tạo Security Group cho ALB và EC2.

#### `aws_security_group.alb`

Security Group cho ALB.

Luật chính:

- Inbound port `80` từ Internet `0.0.0.0/0`.
- Egress TCP port `30080` để ALB forward request tới EC2 NodePort.

#### `aws_security_group.ec2`

Security Group cho EC2 chạy minikube.

Luật chính:

- Inbound SSH port `22` từ `var.ssh_allowed_cidr`.
- Inbound TCP port `30080` chỉ từ ALB Security Group.
- Outbound all để EC2 tải package, minikube binary, Docker image.

Điểm quan trọng: port `30080` không mở trực tiếp ra toàn Internet. Internet chỉ vào qua ALB.

### `terraform/aws_ec2.tf`

File này tạo SSH key bằng TLS provider, tạo AWS Key Pair và tạo EC2 instance.

#### `tls_private_key.minikube`

Terraform dùng TLS provider để tạo private/public key:

```hcl
resource "tls_private_key" "minikube" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
```

Đây là provider thứ hai của project.

#### `aws_key_pair.minikube`

AWS provider dùng public key từ TLS:

```hcl
public_key = tls_private_key.minikube.public_key_openssh
```

Đây là provider wiring thật: TLS tạo key, AWS dùng key đó.

#### `aws_instance.minikube`

Resource này tạo EC2 Ubuntu 22.04.

EC2 được cấu hình:

- AMI Ubuntu từ `data.aws_ami.ubuntu_2204`.
- Instance type từ `var.instance_type`.
- Security Group EC2.
- Public IP.
- Root volume 30GB.
- `user_data = file("${path.module}/user_data.sh")`.

Quan trọng nhất: khi EC2 boot lần đầu, AWS sẽ chạy `terraform/user_data.sh`.

### `terraform/user_data.sh`

Đây là file cực kỳ quan trọng.

Nó chạy tự động bên trong EC2 khi instance được tạo.

Các bước chính:

1. `apt-get update`.
2. Cài package cần thiết: Docker, curl, gnupg, conntrack, socat.
3. Enable Docker.
4. Add user `ubuntu` vào group Docker.
5. Cài `kubectl`.
6. Cài `minikube`.
7. Tạo file Kubernetes manifest `/home/ubuntu/html-app.yaml`.
8. Start minikube bằng Docker driver:

```bash
minikube start \
  --driver=docker \
  --container-runtime=docker \
  --cpus=2 \
  --memory=1800mb \
  --ports=30080:30080
```

9. Tạo namespace `app`.
10. Apply manifest Kubernetes.
11. Đợi Deployment rollout thành công:

```bash
kubectl rollout status deployment/html-app -n app --timeout=180s
```

12. Ghi log sẵn sàng vào:

```text
/var/log/k8s-app-ready.log
```

Manifest Kubernetes trong file này tạo:

- Namespace `app`.
- ConfigMap `html-app-content` chứa HTML/CSS.
- Deployment `html-app` chạy `nginx:alpine`.
- Service `html-service` kiểu NodePort, dùng port `30080`.

Vì vậy app chạy trong Kubernetes, không phải cài trực tiếp lên EC2.

### `terraform/aws_alb.tf`

File này tạo Application Load Balancer thật trên AWS.

Các resource chính:

#### `aws_lb.app`

Tạo ALB internet-facing.

ALB nhận request từ Internet qua port `80`.

#### `aws_lb_target_group.app`

Tạo Target Group port `30080`, protocol HTTP.

Health check:

- Path `/`.
- Matcher `200-399`.
- Interval `30`.
- Timeout `5`.

Target Group sẽ kiểm tra app bằng cách gọi vào EC2 port `30080`.

#### `aws_lb_target_group_attachment.minikube`

Gắn EC2 instance vào Target Group:

```hcl
target_id = aws_instance.minikube.id
port      = var.node_port
```

#### `aws_lb_listener.http`

Tạo listener port `80` cho ALB.

Khi browser gọi ALB URL, listener forward request vào Target Group.

### `terraform/outputs.tf`

File này khai báo output sau khi Terraform apply xong.

Output chính:

- `alb_dns_name`: DNS name của ALB.
- `alb_url`: URL mở trên browser.
- `ec2_public_ip`: public IP của EC2.
- `ssh_command`: câu lệnh SSH mẫu.
- `private_key_pem`: private key do TLS provider tạo, được đánh dấu `sensitive`.

`scripts/up.sh` dùng output `private_key_pem` để ghi file SSH key vào `.generated/minikube-key`.

## Giải Thích Thư Mục `scripts/`

### `scripts/up.sh`

Đây là script dựng toàn bộ project.

Nó được gọi bởi:

```bash
make up
```

Các bước trong script:

1. Xác định `ROOT_DIR` và `TF_DIR`.
2. Tạo thư mục `.generated`.
3. Chạy:

```bash
terraform init
terraform apply -auto-approve
```

4. Lấy private key từ Terraform output:

```bash
terraform output -raw private_key_pem > "$ROOT_DIR/.generated/minikube-key"
```

5. Set quyền key:

```bash
chmod 600 "$ROOT_DIR/.generated/minikube-key"
```

6. Lấy EC2 public IP và ALB URL.
7. SSH vào EC2 để đợi:

```bash
cloud-init status --wait
test -f /var/log/k8s-app-ready.log
```

8. In ra ALB URL và lệnh kiểm tra trên EC2.

Nói cách khác, `up.sh` là file điều phối toàn bộ quy trình dựng hạ tầng và chờ app sẵn sàng.

### `scripts/destroy.sh`

Đây là script xoá toàn bộ project.

Nó được gọi bởi:

```bash
make destroy
```

Các bước:

1. Đi vào thư mục `terraform`.
2. Chạy:

```bash
terraform destroy -auto-approve
```

3. Quay lại root project.
4. Xoá thư mục `.generated`.

Kết quả là AWS infrastructure bị xoá sạch, private key generated cũng bị xoá khỏi máy local.

## Giải Thích Thư Mục `evidence/`

### `evidence/.gitkeep`

Git không commit thư mục rỗng. File `.gitkeep` giúp giữ thư mục `evidence/` trong repo.

Bạn có thể dùng thư mục này để lưu ảnh chụp màn hình hoặc bằng chứng khi demo, ví dụ:

- ALB URL mở được app.
- `kubectl get pods -n app`.
- `kubectl get svc -n app`.
- Terraform output.

Các file evidence thật bị ignore trong `.gitignore`, chỉ giữ lại `.gitkeep`.

## Các File Generated Không Nên Commit

Khi chạy project, một số file/thư mục sẽ được sinh ra:

```text
.generated/
terraform/.terraform/
terraform/terraform.tfstate
terraform/terraform.tfstate.backup
terraform/.terraform.lock.hcl
```

Ý nghĩa:

- `.generated/minikube-key`: private key SSH để vào EC2.
- `terraform/.terraform/`: provider plugin/cache.
- `terraform/terraform.tfstate`: state quản lý hạ tầng.
- `terraform/.terraform.lock.hcl`: lock provider được tạo khi init.

Các file này không nên commit theo yêu cầu bài.

## Luồng Request Khi App Đã Chạy

Sau khi `make up` hoàn tất, người dùng mở ALB URL.

Request đi như sau:

```text
Browser
  -> AWS ALB port 80
  -> Target Group
  -> EC2 public/private network port 30080
  -> Minikube NodePort 30080
  -> Kubernetes Service html-service
  -> Pod nginx trong Deployment html-app
  -> HTML/CSS từ ConfigMap html-app-content
```

Điểm cần nhấn mạnh khi giải thích:

- ALB là thật, được AWS provider tạo.
- EC2 chỉ là host chạy minikube.
- App nằm trong Kubernetes Pod.
- Port `30080` là cầu nối từ ALB vào Kubernetes Service.

## Tóm Tắt Thứ Tự Chạy

### Dựng project

```text
make up
  -> Makefile
  -> scripts/up.sh
  -> terraform init
  -> terraform apply
  -> TLS provider tạo SSH key
  -> AWS provider tạo Key Pair, EC2, SG, ALB
  -> EC2 boot
  -> user_data.sh chạy
  -> cài Docker/kubectl/minikube
  -> minikube start
  -> kubectl apply manifest
  -> app chạy trong Pod
  -> ALB forward vào NodePort
  -> in ALB URL
```

### Xoá project

```text
make destroy
  -> Makefile
  -> scripts/destroy.sh
  -> terraform destroy
  -> xoá AWS resources
  -> xoá .generated
```

## Câu Nói Ngắn Gọn Khi Thuyết Trình

Project này dùng Terraform với 2 provider `aws` và `tls`. Provider `tls` tạo SSH key, public key được truyền sang provider `aws` để tạo AWS Key Pair. AWS provider tạo EC2, Security Group và ALB. Khi EC2 boot, `user_data.sh` cài Docker, kubectl, minikube, sau đó deploy app HTML/CSS vào Kubernetes bằng nginx Pod và Service NodePort `30080`. ALB thật nhận traffic port `80` từ Internet và forward vào EC2 port `30080`, từ đó vào minikube Service rồi tới Pod.
