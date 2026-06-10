# Day A - CI/CD va GitOps

## Muc tieu ngay

Day A tao nen nen tang de dua ung dung Flask vao Kubernetes bang quy trinh tu dong. Muc tieu la co app, Dockerfile, GitHub Actions, Kubernetes manifests va ArgoCD Application.

## Kien thuc chinh

- CI/CD giup kiem tra, build va chuan hoa thay doi truoc khi merge.
- GitHub Actions chay workflow khi push hoac pull request.
- GitOps dung Git lam nguon su that cho trang thai Kubernetes.
- ArgoCD theo doi repo va dong bo manifest vao cluster.
- App of Apps giup quan ly nhieu ArgoCD Application tu mot root app.

## File trong thu muc nay dung de lam gi

- `.github/workflows/ci.yml`: workflow CI mau de install dependency, compile Python va build Docker image.
- `manifests/namespace.yaml`: tao namespace `w9-demo`.
- `manifests/deployment.yaml`: deploy Flask app voi 2 replicas, probes va image placeholder.
- `manifests/service.yaml`: tao ClusterIP Service cho app.
- `argocd/application.yaml`: ArgoCD Application tro den manifest cua app.
- `argocd/app-of-apps.yaml`: root application tro den thu muc ArgoCD.
- `notes.md`: ghi chu ly thuyet cua ngay.
- `evidence.md`: checklist anh va command can chup de nop mentor.

## Cach demo ngan

1. Mo GitHub Actions de cho thay workflow CI da chay.
2. Chay `kubectl apply -f day-a/manifests/`.
3. Chay `kubectl get pods -n w9-demo`.
4. Mo ArgoCD UI va chi ra app `w9-demo-app` dang synced.

## Cau hoi mentor co the hoi

- Tai sao nen dung GitOps thay vi kubectl apply thu cong?
- Readiness probe khac liveness probe nhu the nao?
- ArgoCD automated sync co rui ro gi?
- Khi rollback, luc nao nen dung git revert va luc nao nen dung kubectl rollout undo?
