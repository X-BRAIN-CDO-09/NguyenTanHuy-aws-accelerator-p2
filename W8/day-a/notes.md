# W8 Day A - Terraform Notes

## 1. Infrastructure as Code (IaC)

Infrastructure as Code (IaC) là phương pháp quản lý và cung cấp hạ tầng bằng code thay vì cấu hình thủ công trên giao diện AWS Console.

Lợi ích:

* Dễ quản lý bằng Git.
* Dễ tái sử dụng.
* Giảm lỗi thao tác thủ công.
* Có thể tự động hóa việc triển khai hạ tầng.

---

## 2. Terraform là gì?

Terraform là công cụ Infrastructure as Code do HashiCorp phát triển.

Terraform cho phép khai báo hạ tầng bằng file `.tf` và tự động tạo tài nguyên trên AWS.

Trong bài thực hành này Terraform được sử dụng để tạo S3 Bucket trên AWS.

---

## 3. Các thành phần trong project

### main.tf

Chứa cấu hình chính của Terraform:

* AWS Provider
* S3 Bucket Resource

Terraform sẽ đọc file này để biết cần tạo tài nguyên gì trên AWS.

### variables.tf

Khai báo các biến:

* aws_region
* bucket_name

Giúp thay đổi giá trị mà không cần sửa trực tiếp trong main.tf.

### outputs.tf

Hiển thị kết quả sau khi Terraform Apply:

* bucket_name
* bucket_arn

---

## 4. Terraform Workflow

### terraform init

Khởi tạo project và tải provider cần thiết.

### terraform fmt

Format lại code Terraform theo chuẩn.

### terraform validate

Kiểm tra cấu hình Terraform có hợp lệ hay không.

### terraform plan

Hiển thị kế hoạch thay đổi trước khi áp dụng.

Kết quả bài lab:

Plan: 1 to add, 0 to change, 0 to destroy.

### terraform apply

Tạo tài nguyên thật trên AWS.

Kết quả bài lab:

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

### terraform destroy

Xóa toàn bộ tài nguyên được Terraform quản lý.

---

## 5. Terraform State

Terraform tạo file:

terraform.tfstate

File này lưu trạng thái của các resource mà Terraform đang quản lý.

Nếu mất file state, Terraform có thể không biết tài nguyên nào đã được tạo trước đó.

---

## 6. S3 Bucket được tạo trong bài

Bucket Name:

huy-w8-day-a-terraform-demo-46205

Region:

us-east-1

Tags:

* Name = w8-day-a-demo
* Owner = Huy
* Week = W8
* Day = Day-A
* Environment = Learning

---

## 7. Kiến thức rút ra

* Terraform có thể kết nối AWS thông qua AWS CLI credential.
* Terraform không tạo resource ngay khi chạy plan.
* Terraform chỉ tạo resource khi chạy apply.
* Terraform state rất quan trọng trong việc quản lý hạ tầng.
* S3 Bucket name phải unique trên toàn AWS.
