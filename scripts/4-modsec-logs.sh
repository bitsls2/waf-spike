#!/bin/bash

NAMESPACE="incidents"
POD=$(kubectl get pods -n $NAMESPACE -l app.kubernetes.io/name=ingress-nginx-controller -o jsonpath='{.items[0].metadata.name}')

case "$1" in
  "watch")
    kubectl exec -n $NAMESPACE $POD -- tail -f /var/log/audit/audit.log
    ;;
  "warnings")
    kubectl exec -n $NAMESPACE $POD -- grep "warning" /var/log/audit/audit.log
    ;;
  "rules")
    kubectl exec -n $NAMESPACE $POD -- grep "id [0-9]" /var/log/audit/audit.log
    ;;
  *)
    echo "Usage: $0 {watch|warnings|rules}"
    exit 1
    ;;
esac