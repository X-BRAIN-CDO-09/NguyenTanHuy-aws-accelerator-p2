# W9 Lab - GitOps, Observability va Canary

## Muc tieu lab

Lab nay tich hop ca ba ngay thanh mot demo Cloud/DevOps ca nhan: GitOps-ify W8 platform, bolt-on observability va canary auto-abort.

## Kich ban tich hop

### GitOps-ify W8 platform

Toan bo manifest Kubernetes duoc dua vao Git. ArgoCD doc repo va dong bo trang thai mong muon vao cluster. Khi can thay doi image, replica hoac service, ta sua Git thay vi sua truc tiep trong cluster.

### Bolt-on observability

App expose `/metrics`, OTel Collector thu thap telemetry, Prometheus query metrics va Grafana hien thi dashboard. Alert rule dung SLO/Burn Rate de phat hien khi app tieu error budget qua nhanh.

### Canary auto-abort

Argo Rollouts phat hanh version moi theo tung buoc. AnalysisTemplate query Prometheus. Neu success rate thap hon 95%, rollout bi fail va co the rollback thay vi day loi ra 100% traffic.

## File trong thu muc nay

- `architecture.md`: so do Mermaid cua luong CI/CD, GitOps, Observability va Canary.
- `gitops/application.yaml`: ArgoCD Application cho lab.
- `observability/collector-config.yaml`: cau hinh OTel Collector.
- `observability/slo-burn-rate.yaml`: alert rule SLO/Burn Rate.
- `canary/rollout.yaml`: Rollout CRD.
- `canary/prometheus-analysis.yaml`: AnalysisTemplate dung Prometheus.

## Cach demo ngan

1. Giai thich luong Developer -> GitHub -> GitHub Actions -> ArgoCD -> Kubernetes -> App.
2. Mo dashboard Grafana va Prometheus query.
3. Chay rollout canary va chi ra analysis step.
4. Mo YAML de chung minh repo co du app, GitOps, observability va canary.

## Cau hoi mentor co the hoi

- Repo nay lien ket Day A, Day B va Day C nhu the nao?
- Neu canary fail thi he thong phan ung ra sao?
- Observability giup GitOps an toan hon nhu the nao?
- Vi sao nen de rollback thong qua Git?
