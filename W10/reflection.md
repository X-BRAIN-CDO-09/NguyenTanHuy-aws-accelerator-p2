# Reflection

## Những Gì Đã Học Được

Week 10 giúp liên kết bảo mật Kubernetes với vận hành platform thực tế. RBAC kiểm soát ai được làm gì, admission control kiểm soát workload nào được vào cluster, còn supply chain security kiểm soát artifact nào được phép chạy.

## Thách Thức Lớn Nhất

Thách thức lớn nhất là cân bằng giữa bảo mật và khả năng vận hành. Policy quá lỏng sẽ không giảm rủi ro, nhưng policy quá chặt có thể làm gián đoạn delivery. Vì vậy cần audit mode, evidence, rollout từng bước và quy trình exception rõ ràng.

## Các Khái Niệm Bảo Mật Đã Hiểu

- Least privilege với Role, ClusterRole, RoleBinding và ClusterRoleBinding.
- Admission control bằng Gatekeeper và Kyverno.
- Không lưu secret thật trong Git, dùng External Secrets Operator và AWS Secrets Manager.
- Scan vulnerability bằng Trivy trước khi deploy.
- Ký và verify image bằng Cosign để tăng niềm tin vào artifact.
- NetworkPolicy, ResourceQuota và LimitRange là guardrail nền tảng cho namespace production.

## Điều Muốn Cải Thiện

- Tích hợp thêm policy exception workflow có thời hạn.
- Thêm automated conformance test cho từng control.
- Kết nối evidence với CI artifact và dashboard quan sát tập trung.
- Mở rộng secret rotation sang database user thật và ứng dụng có reload tự động.

## Bài Học Cho Môi Trường Production

Production security không chỉ là manifest đúng. Nó cần ownership rõ ràng, alert có người nhận, policy có giai đoạn audit, runbook có thể thực thi, và evidence đủ mạnh để chứng minh control đang hoạt động. Một platform tốt giúp đội ứng dụng làm đúng mặc định thay vì phải nhớ từng quy tắc thủ công.

