# Incident Response Runbook

## 1. Detect

- Nhận tín hiệu từ alert: Kubernetes events, SIEM, EDR, cloud audit log, admission webhook hoặc cost anomaly.
- Ghi lại thời điểm phát hiện, nguồn alert, cluster context, namespace và workload liên quan.
- Xác nhận đây là sự cố thật hay false positive bằng log và metric độc lập.

## 2. Triage

- Xác định mức độ ảnh hưởng: data exposure, privilege escalation, downtime, cost impact.
- Thu thập evidence chỉ đọc: `kubectl get`, `kubectl describe`, audit log, image digest, recent deploy.
- Gán severity và incident commander.

## 3. Contain

- Cô lập workload bằng NetworkPolicy hoặc scale deployment về 0 nếu cần.
- Thu hồi token, secret hoặc credential nghi bị lộ.
- Tạm dừng pipeline deploy nếu supply chain bị nghi ngờ.

## 4. Eradicate

- Loại bỏ image, manifest hoặc secret không an toàn.
- Patch vulnerability, cập nhật base image, rotate credential.
- Kiểm tra RBAC, admission policy và audit log để tìm persistence.

## 5. Recover

- Deploy phiên bản sạch đã scan và ký.
- Theo dõi metric, log, error rate và business KPI.
- Khôi phục traffic từng bước, ưu tiên canary hoặc progressive rollout.

## 6. Postmortem

- Viết timeline, root cause, impact, detection gap và action items.
- Cập nhật policy, runbook, alert và test để ngăn tái diễn.
- Chia sẻ bài học trong platform review mà không quy trách cá nhân.

