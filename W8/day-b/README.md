# W8 Day B - Kubernetes Basics

## Goal
Practice basic Kubernetes objects on minikube.

## Tools
- Docker
- kubectl
- minikube

## Kubernetes objects
- Deployment
- Pod
- Service
- ConfigMap

## Commands
```bash
minikube start
kubectl get nodes
kubectl apply -f k8s/configmap.yaml
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
kubectl get pods
kubectl get deployments
kubectl get svc
kubectl get configmap
minikube service day-b-nginx-service