# Day A Evidence Checklist

- [ ] Screenshot GitHub Actions workflow thanh cong.
- [ ] Screenshot ArgoCD app `w9-demo-app` o trang thai Synced/Healthy.
- [ ] Screenshot `kubectl get pods -n w9-demo`.
- [ ] Screenshot `kubectl get svc -n w9-demo`.
- [ ] Screenshot response tu `/health` neu port-forward.

## Log command can chay

```bash
python -m compileall app
docker build -t w9-demo-app:test ./app
kubectl apply -f day-a/manifests/
kubectl get pods -n w9-demo
kubectl get svc -n w9-demo
kubectl port-forward svc/w9-demo-app -n w9-demo 8080:80
curl http://localhost:8080/health
```
