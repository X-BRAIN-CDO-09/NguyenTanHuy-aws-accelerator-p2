# F-06 - Image Chưa Ký

## Mô Tả Vấn Đề

Cluster cho phép chạy image chưa có chữ ký hoặc không verify signer identity.

## Tác Động

- Image bị thay thế trong registry mà không bị phát hiện.
- Pipeline hoặc registry compromise có thể đưa artifact độc hại vào cluster.
- Không chứng minh được provenance của release.

## Cách Phát Hiện

```bash
cosign verify ghcr.io/example/platform-api:1.0.0
kubectl get clusterpolicy verify-platform-images
```

## Cách Khắc Phục

- Ký image bằng Cosign keyless hoặc key-based signing.
- Enforce Kyverno `verifyImages` cho namespace production.
- Pin image theo digest và verify signer identity.

## Cách Kiểm Chứng

```bash
kubectl run unsigned-api -n apps-prod --image=ghcr.io/example/platform-api:unsigned
```

Kết quả mong đợi: Kyverno từ chối image chưa ký hoặc signer không khớp policy.

