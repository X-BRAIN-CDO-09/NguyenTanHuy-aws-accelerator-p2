# Runbook - Rollback Deployment Lỗi

## Kịch Bản

Deployment mới gây tăng lỗi HTTP 5xx hoặc crash loop trong production. Cần rollback nhanh nhưng vẫn giữ evidence cho điều tra.

## Quy Trình

1. Xác nhận deployment, namespace, revision và impact.

   ```bash
   kubectl rollout history deployment/platform-api -n platform-prod
   kubectl get deploy platform-api -n platform-prod
   kubectl get pods -n platform-prod -l app.kubernetes.io/name=platform-api
   ```

2. Ghi lại revision hiện tại và image digest.

   ```bash
   kubectl describe deploy platform-api -n platform-prod
   ```

3. Rollback về revision ổn định gần nhất.

   ```bash
   kubectl rollout undo deployment/platform-api -n platform-prod
   kubectl rollout status deployment/platform-api -n platform-prod --timeout=5m
   ```

4. Xác minh sau rollback.

   ```bash
   kubectl get pods -n platform-prod -l app.kubernetes.io/name=platform-api
   kubectl logs -n platform-prod deployment/platform-api --tail=100
   ```

5. Thông báo stakeholder: thời điểm bắt đầu, thời điểm rollback, impact còn lại và owner follow-up.
6. Tạo ticket root cause cho thay đổi lỗi, bổ sung test hoặc policy nếu thiếu.

## Tiêu Chí Thành Công

- Rollout status thành công trong 5 phút.
- Error rate giảm về baseline.
- Không có pod `CrashLoopBackOff`.
- Revision lỗi không tiếp tục được promoted.

