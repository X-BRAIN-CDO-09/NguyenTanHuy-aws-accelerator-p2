#!/usr/bin/env bash
set -euxo pipefail

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y ca-certificates conntrack curl docker.io gnupg socat

systemctl enable --now docker
usermod -aG docker ubuntu

install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key \
  | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
chmod 0644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /" \
  > /etc/apt/sources.list.d/kubernetes.list

apt-get update
apt-get install -y kubectl

curl -Lo /usr/local/bin/minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
chmod +x /usr/local/bin/minikube

cat >/home/ubuntu/html-app.yaml <<'EOF'
apiVersion: v1
kind: Namespace
metadata:
  name: app
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: html-app-content
  namespace: app
data:
  index.html: |
    <!doctype html>
    <html lang="en">
      <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>K8s on AWS - Terraform 1-Click</title>
        <link rel="stylesheet" href="/style.css" />
      </head>
      <body>
        <main class="shell">
          <section class="hero">
            <p class="eyebrow">AWS ALB -> EC2 NodePort -> Minikube</p>
            <h1>Kubernetes app delivered by Terraform</h1>
            <p class="lead">
              This HTML/CSS page is served by nginx inside a Kubernetes Pod,
              then exposed to the Internet through a real AWS Application Load Balancer.
            </p>
            <div class="status-grid">
              <div><span>Runtime</span><strong>Kubernetes</strong></div>
              <div><span>Providers</span><strong>aws + tls</strong></div>
              <div><span>Entry</span><strong>ALB port 80</strong></div>
            </div>
          </section>
        </main>
      </body>
    </html>
  style.css: |
    :root {
      color-scheme: light;
      font-family: Inter, ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
      background: #f6f7f9;
      color: #172033;
    }

    * {
      box-sizing: border-box;
    }

    body {
      margin: 0;
      min-height: 100vh;
      background: linear-gradient(135deg, #f7f8fb 0%, #e9edf4 48%, #f8faf7 100%);
    }

    .shell {
      align-items: center;
      display: flex;
      justify-content: center;
      min-height: 100vh;
      padding: 32px;
    }

    .hero {
      background: rgba(255, 255, 255, 0.88);
      border: 1px solid rgba(23, 32, 51, 0.1);
      border-radius: 8px;
      box-shadow: 0 24px 80px rgba(20, 34, 58, 0.14);
      max-width: 860px;
      padding: 48px;
    }

    .eyebrow {
      color: #1760b5;
      font-size: 0.82rem;
      font-weight: 800;
      margin: 0 0 16px;
      text-transform: uppercase;
    }

    h1 {
      font-size: 4rem;
      line-height: 1;
      margin: 0;
      max-width: 760px;
    }

    .lead {
      color: #40506a;
      font-size: 1.2rem;
      line-height: 1.7;
      margin: 24px 0 0;
      max-width: 720px;
    }

    .status-grid {
      display: grid;
      gap: 12px;
      grid-template-columns: repeat(3, minmax(0, 1fr));
      margin-top: 32px;
    }

    .status-grid div {
      background: #172033;
      border-radius: 8px;
      color: white;
      min-height: 96px;
      padding: 18px;
    }

    .status-grid span {
      color: #aeb9cc;
      display: block;
      font-size: 0.82rem;
      margin-bottom: 10px;
    }

    .status-grid strong {
      display: block;
      font-size: 1rem;
      line-height: 1.3;
    }

    @media (max-width: 720px) {
      .shell {
        padding: 18px;
      }

      .hero {
        padding: 28px;
      }

      h1 {
        font-size: 2.4rem;
      }

      .status-grid {
        grid-template-columns: 1fr;
      }
    }
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: html-app
  namespace: app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: html-app
  template:
    metadata:
      labels:
        app: html-app
    spec:
      containers:
        - name: nginx
          image: nginx:alpine
          ports:
            - containerPort: 80
          volumeMounts:
            - name: web-content
              mountPath: /usr/share/nginx/html
      volumes:
        - name: web-content
          configMap:
            name: html-app-content
---
apiVersion: v1
kind: Service
metadata:
  name: html-service
  namespace: app
spec:
  type: NodePort
  selector:
    app: html-app
  ports:
    - port: 80
      targetPort: 80
      nodePort: 30080
EOF

chown ubuntu:ubuntu /home/ubuntu/html-app.yaml

sudo -iu ubuntu bash <<'EOF' >/var/log/k8s-app-deploy.log 2>&1
set -euxo pipefail
mkdir -p "$HOME/.kube" "$HOME/.minikube"
minikube start \
  --driver=docker \
  --container-runtime=docker \
  --cpus=2 \
  --memory=1800mb \
  --ports=30080:30080
kubectl create namespace app || true
kubectl apply -f "$HOME/html-app.yaml"
kubectl rollout status deployment/html-app -n app --timeout=180s
kubectl get pods -n app
kubectl get svc -n app
EOF

cp /var/log/k8s-app-deploy.log /var/log/k8s-app-ready.log
