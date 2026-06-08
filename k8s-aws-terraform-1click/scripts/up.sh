#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TF_DIR="$ROOT_DIR/terraform"

mkdir -p "$ROOT_DIR/.generated"

cd "$TF_DIR"
terraform init
terraform apply -auto-approve

terraform output -raw private_key_pem > "$ROOT_DIR/.generated/minikube-key"
chmod 600 "$ROOT_DIR/.generated/minikube-key"

EC2_IP="$(terraform output -raw ec2_public_ip)"
ALB_URL="$(terraform output -raw alb_url)"

echo "Waiting for EC2 cloud-init to finish..."
READY=0
for i in {1..10}; do
  if ssh \
    -o StrictHostKeyChecking=no \
    -o UserKnownHostsFile=/dev/null \
    -o ConnectTimeout=10 \
    -i "$ROOT_DIR/.generated/minikube-key" \
    "ubuntu@$EC2_IP" \
    "cloud-init status --wait && test -f /var/log/k8s-app-ready.log"; then
    READY=1
    break
  fi

  echo "Waiting... attempt $i/10"
  sleep 20
done

if [[ "$READY" -ne 1 ]]; then
  echo "EC2 cloud-init or Kubernetes app deployment did not finish in time."
  exit 1
fi

echo ""
echo "Deployment finished."
echo "ALB URL: $ALB_URL"
echo ""
echo "Check on EC2:"
echo "ssh -i .generated/minikube-key ubuntu@$EC2_IP"
echo "kubectl get pods -n app"
echo "kubectl get svc -n app"
