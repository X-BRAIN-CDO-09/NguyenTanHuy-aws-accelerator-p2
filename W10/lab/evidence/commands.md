# Verification Commands

## Kubectl Commands

```bash
kubectl apply -f day-a/rbac/
kubectl get ns apps-dev apps-prod
kubectl auth can-i create deployments --as=system:serviceaccount:apps-dev:developer -n apps-dev
kubectl auth can-i update rolebindings --as=system:serviceaccount:apps-dev:developer -n apps-dev
kubectl auth can-i delete pods --as=system:serviceaccount:apps-prod:sre -n apps-prod
kubectl auth can-i patch deployments --as=system:serviceaccount:apps-prod:viewer -n apps-prod
```

```bash
kubectl apply -f day-a/policies/constraint-template.yaml
kubectl apply -f day-a/policies/require-labels.yaml
kubectl apply -f day-a/policies/require-non-root.yaml
kubectl apply -f day-a/policies/disallow-privileged.yaml
kubectl apply -f day-a/policies/require-resource-limits.yaml
kubectl get constrainttemplates
kubectl get k8srequiredlabels,k8srequiredsecuritycontext,k8sdisallowprivileged,k8srequiredresourcelimits
```

```bash
kubectl apply -f day-b/eso/
kubectl get secretstore aws-secrets-manager -n apps-prod
kubectl get externalsecret platform-api-db -n apps-prod
kubectl describe externalsecret platform-api-db -n apps-prod
kubectl get secret platform-api-db -n apps-prod -o jsonpath='{.metadata.resourceVersion}'
```

```bash
kubectl apply -f day-b/signing/verify-image-policy.yaml
kubectl get clusterpolicy verify-platform-images
kubectl describe clusterpolicy verify-platform-images
```

```bash
kubectl apply -f day-c/platform-bootstrap/
kubectl describe resourcequota platform-prod-quota -n platform-prod
kubectl describe limitrange platform-prod-defaults -n platform-prod
kubectl describe networkpolicy platform-prod-default-deny-and-dns -n platform-prod
```

## Helm Commands

```bash
helm repo add gatekeeper https://open-policy-agent.github.io/gatekeeper/charts
helm repo update
helm upgrade --install gatekeeper gatekeeper/gatekeeper --namespace gatekeeper-system --create-namespace
```

```bash
helm repo add external-secrets https://charts.external-secrets.io
helm repo update
helm upgrade --install external-secrets external-secrets/external-secrets \
  --namespace external-secrets --create-namespace \
  --set installCRDs=true
```

```bash
helm repo add kyverno https://kyverno.github.io/kyverno/
helm repo update
helm upgrade --install kyverno kyverno/kyverno --namespace kyverno --create-namespace
```

## Verification Commands

```bash
trivy image --severity HIGH,CRITICAL --ignore-unfixed --exit-code 1 ghcr.io/example/platform-api:1.0.0
cosign sign --yes ghcr.io/example/platform-api:1.0.0
cosign verify ghcr.io/example/platform-api:1.0.0
kubectl get events -A --sort-by=.lastTimestamp
kubectl get pods -A -o wide
kubectl top pods -A
kubectl top nodes
```

