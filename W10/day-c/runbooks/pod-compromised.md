# Runbook - Pod Bị Compromise

## Kịch Bản

Alert cho thấy pod `platform-api` trong namespace `platform-prod` có outbound traffic bất thường và process lạ. Nghi ngờ container bị khai thác qua vulnerability hoặc credential bị lộ.

## Quy Trình

1. Ghi nhận pod, node, image digest và thời điểm alert.
2. Cô lập egress bằng NetworkPolicy khẩn cấp hoặc scale deployment về 0 nếu rủi ro cao.
3. Không exec vào pod nếu có thể làm thay đổi evidence; ưu tiên snapshot log và audit event.
4. Thu thập:

   ```bash
   kubectl get pod -n platform-prod -o wide
   kubectl describe pod <pod-name> -n platform-prod
   kubectl logs <pod-name> -n platform-prod --all-containers --timestamps
   kubectl get events -n platform-prod --sort-by=.lastTimestamp
   ```

5. Kiểm tra image:

   ```bash
   kubectl get pod <pod-name> -n platform-prod -o jsonpath='{.status.containerStatuses[*].imageID}'
   trivy image <image-digest>
   cosign verify <image-digest>
   ```

6. Rotate secret liên quan bằng AWS Secrets Manager và xác nhận ESO đã đồng bộ.
7. Deploy bản sạch đã scan và ký.
8. Mở postmortem với action items: patch image, bổ sung admission policy, tăng detection.

## Kiểm Chứng Recovery

- Pod mới chạy image digest đã xác minh.
- Không còn outbound traffic bất thường.
- Secret resourceVersion đã đổi sau rotation.
- Error rate và latency trở lại baseline.

