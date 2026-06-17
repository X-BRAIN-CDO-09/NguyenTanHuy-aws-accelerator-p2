# F-04 - Thiếu NetworkPolicy

## Mô Tả Vấn Đề

Namespace không có default deny NetworkPolicy, khiến Pod có thể giao tiếp tự do trong cluster hoặc ra ngoài.

## Tác Động

- Lateral movement sau khi một Pod bị compromise.
- Data exfiltration qua egress không kiểm soát.
- Khó chứng minh segmentation trong audit.

## Cách Phát Hiện

```bash
kubectl get networkpolicy -A
kubectl describe networkpolicy platform-prod-default-deny-and-dns -n platform-prod
```

## Cách Khắc Phục

- Áp dụng default deny ingress và egress.
- Allowlist DNS, ingress controller và database subnet cần thiết.
- Kiểm tra ứng dụng sau khi enforce để tránh chặn nhầm traffic hợp lệ.

## Cách Kiểm Chứng

```bash
kubectl run net-test -n platform-prod --image=curlimages/curl --rm -it -- sh
```

Trong container test, kiểm tra DNS và endpoint được allowlist. Traffic không nằm trong allowlist phải timeout hoặc bị chặn.

