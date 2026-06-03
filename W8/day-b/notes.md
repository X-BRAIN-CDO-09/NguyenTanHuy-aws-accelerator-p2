```md
# W8 Day B - Kubernetes Notes

## Container
Container đóng gói ứng dụng và dependencies để chạy nhất quán trên nhiều môi trường.

## Kubernetes
Kubernetes là nền tảng orchestration dùng để quản lý container.

## Pod
Pod là đơn vị nhỏ nhất trong Kubernetes, chứa một hoặc nhiều container.

## Deployment
Deployment quản lý số lượng Pod mong muốn. Nếu Pod lỗi, Deployment có thể tạo Pod mới thay thế.

## Service
Service tạo endpoint ổn định để truy cập các Pod.

## ConfigMap
ConfigMap lưu cấu hình không nhạy cảm.

## Secret
Secret lưu dữ liệu nhạy cảm như password, token hoặc API key.

## Probe
Probe dùng để kiểm tra container:
- livenessProbe: container còn sống không
- readinessProbe: container sẵn sàng nhận traffic chưa
- startupProbe: container khởi động xong chưa