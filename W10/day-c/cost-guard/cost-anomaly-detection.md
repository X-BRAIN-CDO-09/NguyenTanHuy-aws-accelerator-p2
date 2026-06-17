# Cost Anomaly Detection

## AWS Cost Anomaly Detection

AWS Cost Anomaly Detection theo dõi chi phí bằng machine learning và cảnh báo khi mức chi tiêu lệch khỏi baseline. Với Kubernetes platform, nên tạo monitor theo linked account, service, tag `environment`, tag `owner` và namespace cost allocation nếu dùng Kubecost hoặc CUR enrichment.

## Alert Workflow

1. AWS phát hiện anomaly vượt ngưỡng, ví dụ `estimated impact >= 100 USD`.
2. Alert gửi tới SNS, sau đó chuyển tiếp vào Slack hoặc incident channel.
3. FinOps owner kiểm tra service, account, tag, namespace và thời điểm tăng chi phí.
4. Platform engineer đối chiếu với deploy, autoscaling, LoadBalancer, NAT Gateway, log volume và storage.
5. Nếu là runaway workload, áp dụng ResourceQuota, scale down hoặc rollback.
6. Ghi lại nguyên nhân và action item trong cost review hằng tuần.

## Cost Governance Checklist

- [ ] Namespace production có `ResourceQuota`.
- [ ] Container có request và limit hợp lý.
- [ ] Service `LoadBalancer` được kiểm soát bằng quota hoặc policy.
- [ ] Workload có label `owner`, `environment`, `cost-center`.
- [ ] Log retention được đặt theo phân loại dữ liệu.
- [ ] Autoscaling có min/max replica rõ ràng.
- [ ] Cost anomaly alert có owner và escalation path.
- [ ] Báo cáo chi phí theo team được review định kỳ.

