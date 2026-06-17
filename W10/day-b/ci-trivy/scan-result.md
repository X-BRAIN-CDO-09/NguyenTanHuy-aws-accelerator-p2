# Trivy Scan Result

## Mục Tiêu

Workflow `trivy-scan.yml` scan container image và fail pipeline nếu phát hiện vulnerability mức `HIGH` hoặc `CRITICAL`. Report luôn được upload làm artifact để reviewer có bằng chứng.

## Lệnh Local Tương Đương

```bash
trivy image \
  --severity HIGH,CRITICAL \
  --ignore-unfixed \
  --exit-code 1 \
  --format table \
  --output trivy-report.txt \
  ghcr.io/example/platform-api:1.0.0
```

## Kết Quả Mong Đợi

| Tình huống | Exit code | Hành động |
| --- | --- | --- |
| Không có HIGH/CRITICAL | `0` | Cho phép merge hoặc deploy. |
| Có HIGH/CRITICAL | `1` | Chặn pipeline, mở ticket remediation. |
| Scanner lỗi kỹ thuật | khác `0` | Kiểm tra log workflow và chạy lại. |

## Evidence Checklist

- [ ] Link workflow run.
- [ ] Artifact `trivy-report`.
- [ ] Danh sách CVE trọng yếu và owner xử lý.
- [ ] Commit hoặc image digest đã được scan.

