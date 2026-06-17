# F-01 - RBAC Quá Rộng

## Mô Tả Vấn Đề

User hoặc ServiceAccount có quyền `cluster-admin` hoặc quyền chỉnh RBAC không cần thiết. Điều này phá vỡ nguyên tắc least privilege.

## Tác Động

- Privilege escalation.
- Xóa hoặc sửa workload production.
- Tạo RoleBinding để tự cấp thêm quyền.

## Cách Phát Hiện

```bash
kubectl get clusterrolebinding
kubectl auth can-i create rolebindings --as=system:serviceaccount:apps-dev:developer -n apps-dev
```

## Cách Khắc Phục

- Tách role Developer, SRE, Viewer.
- Developer chỉ được quản lý workload, không được chỉnh RBAC.
- Dùng ClusterRoleBinding rất hạn chế và có owner rõ ràng.

## Cách Kiểm Chứng

```bash
kubectl auth can-i update rolebindings --as=system:serviceaccount:apps-dev:developer -n apps-dev
kubectl auth can-i get pods --as=system:serviceaccount:apps-prod:viewer -n apps-prod
```

Kết quả mong đợi: Developer bị từ chối chỉnh RBAC, Viewer chỉ đọc.

