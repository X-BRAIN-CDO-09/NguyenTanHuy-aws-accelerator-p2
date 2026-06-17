# F-03 - Secret Không An Toàn

## Mô Tả Vấn Đề

Secret thật bị commit vào Git, Kubernetes Secret không được rotate, hoặc credential dùng chung nhiều môi trường.

## Tác Động

- Lộ database password, API token hoặc cloud credential.
- Khó thu hồi khi có incident.
- Tăng rủi ro lateral movement.

## Cách Phát Hiện

```bash
git grep -nE 'password|secret|token|AKIA'
kubectl get secrets -A
kubectl get externalsecret -A
```

## Cách Khắc Phục

- Dùng AWS Secrets Manager làm source of truth.
- Dùng External Secrets Operator để đồng bộ vào Kubernetes.
- Rotate credential theo quy trình và audit access.

## Cách Kiểm Chứng

```bash
kubectl get externalsecret platform-api-db -n apps-prod
kubectl describe externalsecret platform-api-db -n apps-prod
kubectl get secret platform-api-db -n apps-prod -o jsonpath='{.metadata.resourceVersion}'
```

Kết quả mong đợi: ExternalSecret synced và resourceVersion thay đổi sau rotation.

