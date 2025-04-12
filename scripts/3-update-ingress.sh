#!/bin/bash

set -e  # Exit on error

# kubectl apply -f k8s/ingress-nginx/configmap.yaml -n incidents
# kubectl rollout restart deployment ingress-nginx-controller -n incidents

# Remove ModSecurity ConfigMap
echo "Removing ModSecurity ConfigMap..."
kubectl delete configmap modsec-app-rules --namespace incidents || true

cd k8s/ingress-nginx 
# Create ConfigMap for ModSecurity rules
kubectl create configmap modsec-app-rules \
  --from-file="app-rules-before.conf" \
  --namespace incidents

# Create ingress-nginx controller with ModSecurity enabled and custom rules 
# including host based routing to incidents-api using helm charts.
helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace incidents \
  --values ingress-controller-values.yaml

kubectl rollout restart deployment ingress-nginx-controller -n incidents

# Wait for ingress controller pod to be ready
echo "Waiting for ingress controller pod..."
kubectl wait --namespace incidents \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=120s

cd ../..

echo "Done - happy testing!"