# Kubernetes ingress nginx control

Based on deployment instructions 

https://kubernetes.github.io/ingress-nginx/deploy/


## Steps to implement

1. Create a Kubernetes nginx ingress control deployment configuration that can be deployed to kubernetes docker desktop.
2. Create deployment instructions
3. Use helm to configure the controller and enable modsecurity. 

~~~~
bitsls2: Create the steps to create an ingress controller based on the steps.

GitHub Copilot: # Creating an NGINX Ingress Controller with ModSecurity

## Prerequisites
- Docker Desktop with Kubernetes enabled
- Helm CLI installed
- kubectl CLI installed

## Installation Steps

1. Add the official NGINX Ingress Helm repository:
```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
```

2. Create a values file for Helm configuration:

````yaml
controller:
  config:
    enable-modsecurity: "true"
    enable-owasp-modsecurity-crs: "true"
    modsecurity-snippet: |
      SecRuleEngine On
      SecRequestBodyAccess On
      SecAuditEngine RelevantOnly
      SecAuditLog /var/log/modsec_audit.log
  metrics:
    enabled: true
  podAnnotations:
    prometheus.io/scrape: "true"
    prometheus.io/port: "10254"
````

3. Install the NGINX Ingress Controller:
```bash
helm install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --create-namespace \
  --values k8s/ingress-values.yaml
```

4. Verify the installation:
```bash
kubectl get pods -n ingress-nginx
kubectl get services -n ingress-nginx
```

5. Create a test ingress resource:

````yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: test-ingress
  annotations:
    nginx.ingress.kubernetes.io/modsecurity-snippet: |
      SecRuleEngine On
      SecRequestBodyAccess On
spec:
  ingressClassName: nginx
  rules:
  - host: localhost
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: incidents-api
            port:
              number: 80
````

6. Apply the ingress resource:
```bash
kubectl apply -f k8s/test-ingress.yaml
```

7. Verify the ingress is working:
```bash
kubectl get ingress
curl -H "Host: localhost" http://localhost/incidents
```

## Notes
- The ModSecurity WAF is enabled with OWASP Core Rule Set
- Metrics are enabled for Prometheus monitoring
- The ingress controller is accessible on localhost
- Logs can be viewed using:
```bash
kubectl logs -n ingress-nginx -l app.kubernetes.io/name=ingress-nginx
```