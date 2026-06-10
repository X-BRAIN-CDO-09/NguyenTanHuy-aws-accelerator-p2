# W9 Architecture

## So do tong quan

```mermaid
flowchart LR
    Developer[Developer] --> GitHub[GitHub Repository]
    GitHub --> Actions[GitHub Actions]
    Actions --> ArgoCD[ArgoCD]
    ArgoCD --> Kubernetes[Kubernetes Cluster]
    Kubernetes --> App[Flask App]

    App --> OTel[OpenTelemetry Collector]
    OTel --> Prometheus[Prometheus]
    Prometheus --> Grafana[Grafana]

    Rollouts[Argo Rollouts] --> Analysis[Prometheus Analysis]
    Analysis --> Rollback[Rollback / Auto Abort]
    Prometheus --> Analysis
    Rollouts --> Kubernetes
```

## Giai thich ngan

Developer push code len GitHub. GitHub Actions kiem tra va build image mau. ArgoCD doc manifest trong Git va sync vao Kubernetes. App expose health va metrics. OpenTelemetry Collector va Prometheus thu thap tin hieu. Grafana hien thi dashboard. Argo Rollouts dung Prometheus Analysis de quyet dinh tiep tuc, dung lai hoac rollback canary.
