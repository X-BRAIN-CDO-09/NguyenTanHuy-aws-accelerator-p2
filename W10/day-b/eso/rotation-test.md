# External Secrets Rotation Test

## Ý Nghĩa `refreshInterval`

`refreshInterval: 15m` yêu cầu External Secrets Operator kiểm tra AWS Secrets Manager theo chu kỳ 15 phút. Nếu giá trị trong backend thay đổi, ESO cập nhật Kubernetes Secret tương ứng.

## Quy Trình Rotate Secret

1. Tạo phiên bản secret mới trong AWS Secrets Manager cho key `prod/platform-api/database`.
2. Cập nhật trường `password` nhưng giữ format JSON ổn định:

   ```json
   {
     "username": "platform_api",
     "password": "new-strong-password"
   }
   ```

3. Chờ tối đa 15 phút hoặc trigger reconcile bằng annotation.
4. Xác minh Kubernetes Secret đã đổi.
5. Restart workload nếu ứng dụng không tự reload secret từ volume hoặc env.
6. Thu hồi version cũ sau khi xác nhận không còn kết nối dùng credential cũ.

## Lệnh Kiểm Tra

```bash
kubectl get secretstore aws-secrets-manager -n apps-prod
kubectl get externalsecret platform-api-db -n apps-prod
kubectl describe externalsecret platform-api-db -n apps-prod
kubectl get secret platform-api-db -n apps-prod -o jsonpath='{.metadata.resourceVersion}'
```

Trigger reconcile thủ công:

```bash
kubectl annotate externalsecret platform-api-db -n apps-prod \
  force-sync="$(date +%s)" --overwrite
```

Kiểm chứng dữ liệu đã thay đổi mà không in secret ra terminal:

```bash
kubectl get secret platform-api-db -n apps-prod -o jsonpath='{.data.password}' | wc -c
```

## Evidence

- [ ] Ảnh chụp ExternalSecret ở trạng thái `SecretSynced`.
- [ ] Ảnh chụp resourceVersion thay đổi sau rotation.
- [ ] Log restart hoặc reload ứng dụng sau khi secret thay đổi.

