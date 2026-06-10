# Day B Evidence Checklist

- [ ] Screenshot endpoint `/metrics` cua app.
- [ ] Screenshot OpenTelemetry Collector config da apply hoac da mo trong repo.
- [ ] Screenshot Prometheus target hoac query `http_requests_total`.
- [ ] Screenshot Grafana dashboard co 4 panel.
- [ ] Screenshot alert rule SLO/Burn Rate.

## Log command can chay

```bash
kubectl apply -f day-b/otel/collector-config.yaml
kubectl apply -f day-b/alert-rules/slo-burn-rate.yaml
kubectl port-forward svc/w9-demo-app -n w9-demo 8080:80
curl http://localhost:8080/metrics
kubectl get prometheusrule -n monitoring
```
