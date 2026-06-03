# Day C - Kubernetes Networking và Scaling

## Mục tiêu

Tìm hiểu cách triển khai ứng dụng trên Kubernetes bằng Minikube, cấu hình Service, Network Policy và thực hiện Scale Deployment.

## Nội dung thực hiện

### 1. Deployment

* Triển khai ứng dụng nginx lên Kubernetes.
* Tạo Deployment quản lý Pod.
* Thiết lập số lượng Pod ban đầu là 2 replicas.

### 2. Service

* Tạo Service kiểu NodePort.
* Cho phép truy cập ứng dụng nginx từ bên ngoài cluster.

### 3. Network Policy

* Tạo Network Policy giới hạn lưu lượng truy cập.
* Chỉ cho phép truy cập tới các Pod có label `app=day-c-nginx`.

### 4. Scaling

* Scale từ 2 Pod lên 4 Pod.
* Scale từ 4 Pod về 2 Pod.
* Quan sát sự thay đổi số lượng Pod trong cluster.

## Các lệnh kiểm tra

```bash
kubectl get deploy
kubectl get pods
kubectl get svc
kubectl get networkpolicy
```

## Kết quả

* Deployment tạo thành công.
* Service hoạt động bình thường.
* Network Policy được áp dụng thành công.
* Scale Up và Scale Down thành công.
* Truy cập được ứng dụng nginx thông qua Minikube Service.
