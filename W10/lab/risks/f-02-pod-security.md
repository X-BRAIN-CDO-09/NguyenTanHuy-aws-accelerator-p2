# F-02 - Pod Security Yếu

## Mô Tả Vấn Đề

Pod chạy privileged, chạy root, thiếu securityContext hoặc thiếu resource limits.

## Tác Động

- Container breakout hoặc tăng blast radius khi bị khai thác.
- Node bị chiếm tài nguyên.
- Không đạt chuẩn Pod Security Standards.

## Cách Phát Hiện

```bash
kubectl get pods -A -o jsonpath='{range .items[*]}{.metadata.namespace}{" "}{.metadata.name}{"\n"}{end}'
kubectl get k8sdisallowprivileged
kubectl get k8srequiredsecuritycontext
```

## Cách Khắc Phục

- Enforce non-root container.
- Disallow privileged container.
- Bắt buộc CPU và memory limits.
- Bật Pod Security Admission label cho namespace.

## Cách Kiểm Chứng

Tạo pod privileged để kiểm tra admission rejection:

```bash
kubectl run bad-privileged -n apps-prod --image=nginx:1.25 \
  --overrides='{"spec":{"containers":[{"name":"bad-privileged","image":"nginx:1.25","securityContext":{"privileged":true}}]}}'
```

Kết quả mong đợi: API server trả lỗi Forbidden từ Gatekeeper.

