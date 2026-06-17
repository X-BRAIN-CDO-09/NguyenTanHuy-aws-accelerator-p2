# Week 10 - Secure & Operate: RBAC + Secrets + Platform Integration

Repository này là portfolio lab cho Kubernetes Security và DevSecOps platform operations. Nội dung mô phỏng cách một platform team thiết kế quyền truy cập, admission control, quản lý secrets, kiểm soát supply chain, runbook vận hành và cost governance cho môi trường production.

## Mục Tiêu Học Tập

| Nhóm năng lực | Kết quả mong đợi |
| --- | --- |
| Kubernetes Security | Thiết kế namespace, ServiceAccount, RBAC, policy admission và network boundary. |
| Admission Control | Áp dụng OPA Gatekeeper để audit và enforce label, non-root, privileged pod và resource limit. |
| Secrets Management | Đồng bộ secret từ AWS Secrets Manager bằng External Secrets Operator và kiểm thử rotation. |
| Supply Chain Security | Scan image bằng Trivy, ký image bằng Cosign, enforce chữ ký bằng Kyverno. |
| Platform Operations | Bootstrap namespace production với ResourceQuota, LimitRange và NetworkPolicy. |
| Incident Response | Viết runbook detect, triage, contain, eradicate, recover và postmortem. |
| Cost Governance | Thiết kế cảnh báo AWS Cost Anomaly Detection và checklist kiểm soát chi phí. |

## Kiến Trúc Hệ Thống

```text
Developer/SRE/Viewer
        |
        v
Kubernetes API Server
        |
        +-- RBAC authorization
        +-- Gatekeeper/Kyverno admission policies
        +-- External Secrets Operator
        +-- Workload namespaces with quota, limits, network policy
        |
        v
Container registry + CI pipeline
        |
        +-- Trivy image scan
        +-- Cosign signing and verification
```

## Security Controls

| Control | Công cụ | Mục đích | Trạng thái lab |
| --- | --- | --- | --- |
| Least privilege access | Kubernetes RBAC | Tách quyền Developer, SRE và Viewer. | `day-a/rbac` |
| Policy admission | OPA Gatekeeper | Chặn workload thiếu chuẩn bảo mật. | `day-a/policies` |
| External secrets | External Secrets Operator | Không lưu secret thật trong Git. | `day-b/eso` |
| Vulnerability scan | Trivy | Fail CI nếu image có HIGH hoặc CRITICAL. | `day-b/ci-trivy` |
| Image signing | Cosign + Kyverno | Chỉ cho phép image đã ký. | `day-b/signing` |
| Platform guardrails | Quota, LimitRange, NetworkPolicy | Giới hạn tài nguyên và giảm blast radius. | `day-c/platform-bootstrap` |
| Operations readiness | Runbooks | Chuẩn hóa phản ứng sự cố và rollback. | `day-c/runbooks` |
| Cost governance | AWS Cost Anomaly Detection | Phát hiện bất thường chi phí. | `day-c/cost-guard` |

## Validation Steps

1. Apply RBAC manifests:

   ```bash
   kubectl apply -f day-a/rbac/
   kubectl auth can-i create deployments --as=system:serviceaccount:apps-dev:developer -n apps-dev
   ```

2. Install Gatekeeper, then apply policies:

   ```bash
   kubectl apply -f day-a/policies/constraint-template.yaml
   kubectl apply -f day-a/policies/
   kubectl get k8srequiredlabels
   ```

3. Install External Secrets Operator, configure AWS IAM access, then apply ESO examples:

   ```bash
   kubectl apply -f day-b/eso/
   kubectl get externalsecret -n apps-prod
   ```

4. Run Trivy in CI or locally:

   ```bash
   trivy image --severity HIGH,CRITICAL --exit-code 1 nginx:1.25
   ```

5. Sign and verify image:

   ```bash
   cosign sign --yes ghcr.io/example/platform-api:1.0.0
   cosign verify ghcr.io/example/platform-api:1.0.0
   ```

6. Bootstrap production namespace guardrails:

   ```bash
   kubectl apply -f day-c/platform-bootstrap/
   kubectl describe resourcequota platform-prod-quota -n platform-prod
   ```

## Folder Structure

```text
.
├── day-a/
│   ├── rbac/
│   └── policies/
├── day-b/
│   ├── eso/
│   ├── ci-trivy/
│   └── signing/
├── day-c/
│   ├── platform-bootstrap/
│   ├── runbooks/
│   └── cost-guard/
├── lab/
│   ├── risks/
│   └── evidence/
└── reflection.md
```

## References

- Kubernetes RBAC documentation: https://kubernetes.io/docs/reference/access-authn-authz/rbac/
- Kubernetes Pod Security Standards: https://kubernetes.io/docs/concepts/security/pod-security-standards/
- OPA Gatekeeper: https://open-policy-agent.github.io/gatekeeper/website/
- External Secrets Operator: https://external-secrets.io/
- Trivy: https://aquasecurity.github.io/trivy/
- Cosign: https://docs.sigstore.dev/cosign/
- Kyverno verifyImages: https://kyverno.io/docs/writing-policies/verify-images/

