# Day C - Platform Integration

Day C gom các control bảo mật vào vận hành platform: bootstrap namespace production, runbook sự cố, rollback và cost governance.

## Nội Dung

| Thư mục | Nội dung |
| --- | --- |
| `platform-bootstrap` | Namespace, ResourceQuota, LimitRange và NetworkPolicy có comment từng field. |
| `runbooks` | Incident response, pod compromised và rollback deployment. |
| `cost-guard` | AWS Cost Anomaly Detection và checklist cost governance. |

## Kết Quả Mong Đợi

- Namespace production có guardrail mặc định trước khi workload được deploy.
- Đội vận hành có quy trình xử lý sự cố thống nhất.
- Rollback deployment có bước xác minh và truyền thông rõ ràng.
- Chi phí bất thường được phát hiện và có owner xử lý.

