# Day A - RBAC + Admission Control

Day A tập trung vào hai lớp bảo vệ đầu tiên của Kubernetes API: authorization bằng RBAC và admission control bằng OPA Gatekeeper.

## Nội Dung

| Thư mục | Nội dung |
| --- | --- |
| `rbac` | Namespace, ServiceAccount, Role, ClusterRole và RoleBinding cho Developer, SRE, Viewer. |
| `policies` | Gatekeeper ConstraintTemplate và Constraints cho label, non-root, privileged pod và resource limits. |

## Kết Quả Mong Đợi

- Developer có thể triển khai workload trong namespace ứng dụng nhưng không thể chỉnh Role, RoleBinding hoặc ClusterRole.
- SRE có quyền quản trị cao để vận hành namespace production và xử lý sự cố.
- Viewer chỉ có quyền đọc tài nguyên.
- Gatekeeper có thể chạy ở audit mode để quan sát vi phạm trước khi chuyển sang enforce mode.
- Pod không đạt chuẩn bảo mật bị admission webhook từ chối.

