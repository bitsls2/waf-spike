#!/bin/bash

set -e  # Exit on error

# Add and update Helm repo
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

# Create namespace
kubectl create namespace incidents || true

# Set context to incidents namespace
kubectl config set-context --current --namespace=incidents

# Create backend incidents api based on json-server & configmap json
cd k8s/incident-api 
kubectl apply -f configmap.yaml
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
cd ../..

cd k8s/ingress-nginx 

# Create ConfigMap for ModSecurity rule exclusions
kubectl create configmap modsec-app-rules \
  --from-file="app-rules-before.conf" \
  --namespace incidents

# Create ingress-nginx controller with ModSecurity enabled and custom rules 
# including host based routing to incidents-api using helm charts.
helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace incidents \
  --values ingress-controller-values.yaml

# Wait for ingress controller pod to be ready
echo "Waiting for ingress controller pod..."
kubectl wait --namespace incidents \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=120s

# Create ingress resource for incidents-api 
kubectl apply -f ingress.yaml

cd ../..

# Wait for deployment
kubectl rollout status deployment/incidents-api

# verify ingress working
echo "Verifying ingress..."
kubectl get ingress -n incidents
kubectl describe ingress incidents-ingress -n incidents


# Display service info
echo "Service Status:"
kubectl get svc
echo -e "\nIngress Status:"
kubectl get ingress

echo "\nAccess the incidents API at:"
echo "curl http://localhost/incidents"

# Debug info
echo -e "\nDebug information:"
kubectl get pods
kubectl get svc ingress-nginx-controller
kubectl describe ingress