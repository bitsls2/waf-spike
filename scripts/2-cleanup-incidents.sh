#!/bin/bash

set -e  # Exit on error

# Set context to incidents namespace
kubectl config set-context --current --namespace=incidents

echo "Cleaning up incidents deployment..."

# Remove ingress resource
echo "Removing ingress..."
kubectl delete ingress incidents-ingress || true

# Uninstall ingress-nginx helm release
echo "Uninstalling ingress-nginx controller..."
helm uninstall ingress-nginx --namespace incidents || true

# Remove ModSecurity ConfigMap
echo "Removing ModSecurity ConfigMap..."
kubectl delete configmap modsec-app-rules --namespace incidents || true

# Remove backend resources
echo "Removing backend resources..."
kubectl delete service incidents-api --namespace incidents || true
kubectl delete deployment incidents-api --namespace incidents || true
kubectl delete configmap incidents-data --namespace incidents || true

# Remove namespace
echo "Removing incidents namespace..."
kubectl delete namespace incidents || true

# Reset default namespace
kubectl config set-context --current --namespace=default

echo "Cleanup complete. You can now run the deployment script again."