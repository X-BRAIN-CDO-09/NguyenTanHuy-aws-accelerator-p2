# Day B - Secrets + Supply Chain Security

Day B tập trung vào bảo vệ dữ liệu nhạy cảm và nguồn gốc container image.

## Nội Dung

| Thư mục | Nội dung |
| --- | --- |
| `eso` | Ví dụ External Secrets Operator dùng AWS Secrets Manager. |
| `ci-trivy` | GitHub Actions workflow scan image bằng Trivy và upload report. |
| `signing` | Lệnh Cosign và Kyverno policy verify image signature. |

## Kết Quả Mong Đợi

- Secret thật không nằm trong Git.
- Secret được đồng bộ theo `refreshInterval` và có quy trình rotation rõ ràng.
- CI fail khi image có vulnerability mức HIGH hoặc CRITICAL.
- Admission policy từ chối image chưa được ký.

