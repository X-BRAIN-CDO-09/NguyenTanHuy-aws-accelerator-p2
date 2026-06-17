# F-05 - Image Chưa Được Scan

## Mô Tả Vấn Đề

Container image được deploy mà không qua vulnerability scanning hoặc pipeline vẫn pass dù có CVE mức cao.

## Tác Động

- Đưa vulnerability đã biết vào production.
- Tăng rủi ro exploit tự động.
- Không có artifact bằng chứng cho audit.

## Cách Phát Hiện

```bash
trivy image --severity HIGH,CRITICAL ghcr.io/example/platform-api:1.0.0
gh run list --workflow trivy-image-scan
```

## Cách Khắc Phục

- Thêm Trivy vào CI.
- Fail pipeline khi có HIGH hoặc CRITICAL.
- Upload report artifact và gán owner xử lý CVE.

## Cách Kiểm Chứng

```bash
trivy image --severity HIGH,CRITICAL --ignore-unfixed --exit-code 1 ghcr.io/example/platform-api:1.0.0
```

Kết quả mong đợi: image sạch trả exit code `0`; image có HIGH/CRITICAL trả exit code `1`.

