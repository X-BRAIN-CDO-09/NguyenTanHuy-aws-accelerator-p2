# RBAC Verification

Áp dụng manifests:

```bash
kubectl apply -f day-a/rbac/
```

## Developer

```bash
kubectl auth can-i create deployments \
  --as=system:serviceaccount:apps-dev:developer \
  -n apps-dev
```

Kết quả mong đợi:

```text
yes
```

```bash
kubectl auth can-i update rolebindings \
  --as=system:serviceaccount:apps-dev:developer \
  -n apps-dev
```

Kết quả mong đợi:

```text
no
```

## SRE

```bash
kubectl auth can-i delete pods \
  --as=system:serviceaccount:apps-prod:sre \
  -n apps-prod
kubectl auth can-i create rolebindings \
  --as=system:serviceaccount:apps-prod:sre \
  -n apps-prod
```

Kết quả mong đợi:

```text
yes
yes
```

## Viewer

```bash
kubectl auth can-i get pods \
  --as=system:serviceaccount:apps-prod:viewer \
  -n apps-prod
kubectl auth can-i patch deployments \
  --as=system:serviceaccount:apps-prod:viewer \
  -n apps-prod
```

Kết quả mong đợi:

```text
yes
no
```

## Evidence Checklist

- [ ] Ảnh chụp lệnh `kubectl auth can-i` cho Developer deploy workload.
- [ ] Ảnh chụp Developer bị từ chối chỉnh RBAC.
- [ ] Ảnh chụp SRE có quyền vận hành production.
- [ ] Ảnh chụp Viewer chỉ đọc.
- [ ] Ghi lại cluster context, ngày kiểm thử và người kiểm thử.

