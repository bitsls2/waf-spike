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

## Resources

Explanation:
CPU Settings:

200m limit = 0.2 cores maximum
100m request = 0.1 cores guaranteed
JSON server typically doesn't need more than 0.2 cores
Memory Settings:

128Mi limit = maximum memory allowed
64Mi request = guaranteed memory
Node.js-based JSON server runs efficiently within these bounds
Rationale:

JSON server is a lightweight service
Request/limit ratio of 1:2 follows Kubernetes best practices
Prevents resource hogging while ensuring stability
You can monitor actual usage with:

```bash
kubectl top pod -l app=incidents-api -n incidents
```


```bash
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t bitsls2/json-server:latest \
  --push \
  json-server/
```

# Pushing to Docker Registry

Here's how to push your Docker image to a registry:

1. First, log in to your Docker registry:
```bash
docker login
```

2. Tag your image with the registry name:
```bash
docker tag json-server:latest your-username/json-server:latest
```

3. For multi-platform builds using buildx:
````bash
#!/bin/bash
set -e

# Create and use multi-platform builder
docker buildx create --name multiplatform --use
docker buildx inspect --bootstrap

# Build and push for multiple platforms
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t your-username/json-server:latest \
  --push \
  json-server/
````

Make the script executable:
```bash
chmod +x scripts/build-push.sh
```

Replace `your-username` with your Docker Hub username.

To verify the push:
```bash
docker buildx imagetools inspect your-username/json-server:latest
```

# Pushing to Docker Registry

Here's how to push your Docker image to a registry:

1. First, log in to your Docker registry:
```bash
docker login
```

2. Tag your image with the registry name:
```bash
docker tag json-server:latest your-username/json-server:latest
```

3. For multi-platform builds using buildx:
````bash
#!/bin/bash
set -e

# Create and use multi-platform builder
docker buildx create --name multiplatform --use
docker buildx inspect --bootstrap

# Build and push for multiple platforms
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t your-username/json-server:latest \
  --push \
  json-server/
````

# Configuring ModSecurity Audit Logging

To configure ModSecurity audit logging in the ingress-nginx controller, update the ingress-controller-values.yaml with the following configuration:

````yaml
controller:
  config:
    # ...existing modsecurity config...
    modsecurity-snippet: |
      SecRuleEngine On
      SecRequestBodyAccess On
      SecResponseBodyAccess On
      
      # Audit Log Configuration
      SecAuditEngine RelevantOnly
      SecAuditLogParts ABIJDEFHZ
      SecAuditLogType Serial
      SecAuditLog /var/log/audit/audit.log
      SecAuditLogStorageDir /var/log/audit/
      
      # Audit Log Format
      SecAuditLogFormat JSON
      
      # Include existing rules
      Include /etc/nginx/owasp-modsecurity-crs/plugins/app-rules-before.conf
      Include /etc/nginx/owasp-modsecurity-crs/nginx-modsecurity.conf
````

Then add a volume mount for the audit logs:

````yaml
  extraVolumeMounts:
    - name: audit-logs
      mountPath: /var/log/audit
    # ...existing volume mounts...

  extraVolumes:
    - name: audit-logs
      emptyDir: {}
    # ...existing volumes...
````

To verify the logs are being written:

```bash
# Get the ingress controller pod name
POD_NAME=$(kubectl get pods -n incidents -l app.kubernetes.io/name=ingress-nginx-controller -o jsonpath='{.items[0].metadata.name}')

# View the audit logs
kubectl exec -n incidents $POD_NAME -- tail -f /var/log/audit/audit.log
```

## Audit logs



The audit log parts (ABIJDEFHZ) represent:
- A: Audit log header
- B: Request headers
- I: Request body
- J: Upload files
- D: Response headers
- E: Response body
- F: Audit log trailer
- H: Audit log header (additional data)
- Z: End of entry marker


