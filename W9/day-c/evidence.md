# Day C Evidence Checklist

- [ ] Screenshot Argo Rollouts dashboard hoac CLI.
- [ ] Screenshot `kubectl argo rollouts get rollout w9-demo-rollout -n w9-demo`.
- [ ] Screenshot AnalysisTemplate `w9-success-rate`.
- [ ] Screenshot Prometheus query success rate.
- [ ] Screenshot rollout pause/analysis/canary steps.

## Log command can chay

```bash
kubectl apply -f day-c/analysis-template/prometheus-analysis.yaml
kubectl apply -f day-c/rollout/
kubectl argo rollouts get rollout w9-demo-rollout -n w9-demo
kubectl argo rollouts promote w9-demo-rollout -n w9-demo
kubectl argo rollouts abort w9-demo-rollout -n w9-demo
```
