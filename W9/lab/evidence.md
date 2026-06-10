# Lab Evidence Checklist

- [ ] Screenshot GitHub Actions build.
- [ ] Screenshot ArgoCD root/app synced.
- [ ] Screenshot Kubernetes pods va services.
- [ ] Screenshot Prometheus query `http_requests_total`.
- [ ] Screenshot Grafana dashboard.
- [ ] Screenshot Argo Rollouts canary analysis.
- [ ] Screenshot rollback hoac abort scenario neu demo duoc.

## Log command can chay

```bash
kubectl apply -f lab/gitops/application.yaml
kubectl apply -f lab/observability/
kubectl apply -f lab/canary/
kubectl get pods -n w9-demo
kubectl argo rollouts get rollout w9-demo-rollout -n w9-demo
```
