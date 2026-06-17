# Lab - 6-Risk Cluster Cleanup and Enforcement

Lab này mô phỏng một cluster có 6 nhóm rủi ro phổ biến. Mục tiêu là phát hiện, khắc phục và chứng minh bằng evidence rằng cluster đã được harden.

## Sáu Nhóm Rủi Ro

| Mã | Rủi ro | Control chính |
| --- | --- | --- |
| F-01 | RBAC quá rộng | Least privilege, `kubectl auth can-i`. |
| F-02 | Pod security yếu | Gatekeeper, Pod Security Admission. |
| F-03 | Secret trong Git hoặc Secret không rotate | ESO, AWS Secrets Manager. |
| F-04 | Thiếu NetworkPolicy | Default deny, allowlist egress. |
| F-05 | Image có vulnerability | Trivy scan fail HIGH/CRITICAL. |
| F-06 | Image chưa ký | Cosign và Kyverno verifyImages. |

## Cách Làm Lab

1. Kiểm tra từng rủi ro trong `lab/risks`.
2. Áp dụng control tương ứng từ `day-a`, `day-b`, `day-c`.
3. Chạy verification command trong `lab/evidence/commands.md`.
4. Ghi evidence vào `lab/evidence/screenshots.md`.
5. Chỉ xem lab hoàn thành khi mọi checklist có bằng chứng.

