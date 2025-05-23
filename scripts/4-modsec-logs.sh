#!/bin/bash

NAMESPACE="incidents"
# AUDIT_FILE="audit-logs-$(date +%Y%m%d-%H%M%S).log"
# ERROR_FILE="error-logs-$(date +%Y%m%d-%H%M%S).log"
AUDIT_FILE="audit-logs.log"
ERROR_FILE="error-logs.log"

# Create/clear output file
echo "ModSecurity Audit Logs - Generated $(date)" > $AUDIT_FILE
echo "=================================" >> $AUDIT_FILE

# Create/clear output file
echo "ModSecurity Error Logs - Generated $(date)" > $ERROR_FILE
echo "=================================" >> $ERROR_FILE

# Get all ingress-nginx pod names
PODS=$(kubectl get pods -n $NAMESPACE -l app.kubernetes.io/name=ingress-nginx-controller -o jsonpath='{.items[*].metadata.name}')

# Loop through each pod
for POD in $PODS; do
    echo "=== Getting logs from pod: $POD ==="
    
    # Get ModSecurity audit logs
    echo "ModSecurity Audit Logs:" | tee -a $AUDIT_FILE
    kubectl exec -n $NAMESPACE -it $POD -- sh -c "cat /var/log/audit/audit.log | grep OWASP_CRS" 2>/dev/null | tee -a $AUDIT_FILE || true
    
    echo -e "\n=== End of logs for pod: $POD ===\n" | tee -a $AUDIT_FILE

    # Get nginx error logs
    echo -e "NGINX Error Logs:" | tee -a $ERROR_FILE
    kubectl logs -n $NAMESPACE $POD | grep "ModSecurity" 2>/dev/null | tee -a $ERROR_FILE || true
    
    echo -e "\n=== End of logs for pod: $POD ===\n" | tee -a $ERROR_FILE
done


# Example: Filter for last hour using timestamps
# grep "$(date -d '1 hour ago' +'%Y/%m/%d %H:')"