# Ghi chú Day C

## Deployment

Deployment dùng để quản lý Pod và đảm bảo luôn có đủ số lượng Pod mong muốn.

Lệnh kiểm tra:

```bash
kubectl get deploy
kubectl describe deploy day-c-nginx
```

## Service

Service cung cấp địa chỉ truy cập ổn định cho Pod.

Trong bài thực hành sử dụng:

* NodePort Service

Lệnh kiểm tra:

```bash
kubectl get svc
kubectl describe svc day-c-nginx-service
```

## Network Policy

Network Policy dùng để kiểm soát luồng mạng giữa các Pod.

Lợi ích:

* Tăng tính bảo mật
* Hạn chế truy cập trái phép
* Kiểm soát Ingress/Egress

Lệnh kiểm tra:

```bash
kubectl get networkpolicy
kubectl describe networkpolicy allow-nginx-ingress
```

## Scaling

Tăng số lượng Pod:

```bash
kubectl scale deployment/day-c-nginx --replicas=4
```

Giảm số lượng Pod:

```bash
kubectl scale deployment/day-c-nginx --replicas=2
```

Kiểm tra:

```bash
kubectl get pods
```

## Kiến thức học được

* Hiểu cách hoạt động của Deployment.
* Hiểu vai trò của Service trong Kubernetes.
* Hiểu cơ chế Network Policy.
* Hiểu cách Scale ứng dụng trên Kubernetes.
* Làm quen với môi trường Minikube.
