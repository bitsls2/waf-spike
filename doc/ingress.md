# Kubernetes ingress nginx control

Based on deployment instructions: 

[ingress nginx deploy](https://kubernetes.github.io/ingress-nginx/deploy/): doc 

## Prerequisites
- Docker Desktop with Kubernetes enabled
- Helm CLI installed
- kubectl CLI installed

## Useful Commands

Add the official NGINX Ingress Helm repository:
```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
```
Set a namespace.
```bash
kubectl config set-context --current --namespace=incidents
``` 

Apply API manifest

```bash 
# create backend api
cd k8s/incidents-api/
kubectl apply -f .
```
