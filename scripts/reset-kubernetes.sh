#!/bin/bash

echo "Cleaning up Kubernetes environment..."

# Delete all resources in all namespaces
kubectl delete all --all --all-namespaces

# Delete namespaces (except kube-system and default)
for ns in $(kubectl get ns -o jsonpath='{.items[*].metadata.name}' | tr ' ' '\n' | grep -v -e '^kube-system$' -e '^default$')
do
  kubectl delete namespace $ns
done

# Delete persistent volumes and claims
kubectl delete pv --all
kubectl delete pvc --all --all-namespaces

# Remove Helm releases
helm list --all-namespaces | tail -n +2 | awk '{print $1}' | xargs -L1 helm uninstall -n $(awk '{print $2}')

echo "Resetting Docker Desktop Kubernetes..."

# Reset Docker Desktop Kubernetes
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # For WSL/Linux
    wsl.exe -d "docker-desktop" sh -c "kill -9 \$(pidof kubelet)"
fi

echo "Waiting for Kubernetes to restart..."
sleep 10

# Wait for Kubernetes to be ready
kubectl wait --for=condition=Ready nodes --all --timeout=300s

echo "Kubernetes environment has been reset"