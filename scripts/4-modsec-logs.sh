#!/bin/bash

kubectl get pods -n incidents -l app.kubernetes.io/name=ingress-nginx -o jsonpath='{.items[0].metadata.name}'

NAMESPACE="incidents"
POD=$(kubectl get pods -n $NAMESPACE -l app.kubernetes.io/name=ingress-nginx -o jsonpath='{.items[0].metadata.name}')

kubectl exec -n $NAMESPACE -it $POD -- sh -c "cat /var/log/audit/audit.log | grep id:9500001"


