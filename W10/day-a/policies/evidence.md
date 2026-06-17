# Gatekeeper Evidence

## Audit Mode

Audit mode dùng `enforcementAction: dryrun`. Gatekeeper không chặn request, nhưng ghi violation vào status của constraint. Cách này phù hợp khi rollout policy mới để đo số workload bị ảnh hưởng.

```bash
kubectl get k8srequiredlabels require-standard-workload-labels -o yaml
kubectl get k8srequiredresourcelimits require-container-resource-limits -o yaml
```

## Enforce Mode

Enforce mode dùng `enforcementAction: deny`. Request không đạt chuẩn sẽ bị admission webhook từ chối ngay tại API server.

```bash
kubectl get k8srequiredsecuritycontext require-non-root-containers
kubectl get k8sdisallowprivileged disallow-privileged-containers
```

## Cách Kiểm Thử

Pod hợp lệ:

```bash
kubectl run secure-nginx -n apps-prod --image=nginx:1.25 \
  --labels='app.kubernetes.io/name=secure-nginx,app.kubernetes.io/owner=platform,environment=prod' \
  --overrides='{"spec":{"containers":[{"name":"secure-nginx","image":"nginx:1.25","securityContext":{"runAsNonRoot":true,"runAsUser":101},"resources":{"limits":{"cpu":"200m","memory":"128Mi"}}}]}}'
```

Pod bị từ chối vì chạy privileged:

```bash
kubectl run bad-privileged -n apps-prod --image=nginx:1.25 \
  --overrides='{"spec":{"containers":[{"name":"bad-privileged","image":"nginx:1.25","securityContext":{"privileged":true}}]}}'
```

Ví dụ kết quả bị từ chối:

```text
Error from server (Forbidden): admission webhook "validation.gatekeeper.sh" denied the request: container bad-privileged must not run privileged
```

## Evidence Checklist

- [ ] ConstraintTemplate đã được apply thành công.
- [ ] Constraint ở audit mode có violation status.
- [ ] Constraint ở enforce mode từ chối pod không hợp lệ.
- [ ] Log admission rejection được lưu trong `lab/evidence/screenshots.md`.

