# Create a REST API Stub with nginx ingress and a WAF 

## Overview

Experiment with K8 nginx ingress controller using helm chart deployment. Show that is can be used with ModSecurity WAF and a custom plugin to create rule exclusions. 

The rule exclusions are used to tune the OWASP core rule set and to prevent false  positives.

The idea is to develop a policy for tunning the OWASP core rule set in a K8 environment.  

### References

- [Kubernetes/ingress-nginx modsecurity](https://github.com/kubernetes/ingress-nginx/blob/main/docs/user-guide/third-party-addons/modsecurity.md) : Documentation for ingress
- [Handling False Positives with the OWASP ModSecurity Core Rule Set](https://www.netnea.com/cms/apache-tutorial-8_handling-false-positives-modsecurity-core-rule-set/): Tutorial on Handling False positives
- [Core Rule Set with Kubernetes](https://coreruleset.org/docs/5-advanced-topics/5-3-kubernetes-ingress-controller/): Advanced topics on K8s & CRS
- [Owasp Core Rule Set and Plugin registry](https://coreruleset.org/docs/5-advanced-topics/5-3-kubernetes-ingress-controller/): Github documentation on how to write plugins.

## Goal
This project shall: 
- Create a REST API Stub for Incident creation that will support basic CRUD.
- Incidents will contain an : Id, creation date, type, title, description.
- The stub should use `json-server` container image.
- A data file called db.json should be used to seed the rest API.
- The datafile should be generated using faker-js.
- Generating a realistic description for incidents is the key as this will allow the testing of the the WAF.
- Use Kubernetes locally on Docker Desktop.
- Expose the incidents api on localhost via nginx ingress.
- Use Helm Chart for nginx ingress and K8 manifests for the rest.
- Use ModSecurity with Core Rule Set with ingress
- Use a plugin for rule exclusions.

Note: Although the `faker-js` is used to create fake requests, it is thought AI might be used to create more realistic test data dependent on use case.

### Environment set up

Tested with 

- docker destop kubernetes on windows
- wsl unbuntu used for helm and kubectl

## Prerequisites
- Docker Desktop with Kubernetes enabled
- Helm CLI installed
- kubectl CLI installed

## IDE

Suggested IDE 
- VSCode

suggested extensions

- Kubernetes
- REST Cient

and a markdown preview extension

## K8s Stuff

Deploy the incidents service & nginx ingress controller with modsecurity in a incidents namespace.

```bash
./scripts/1-deploy-incidents.sh
```

Clean up the incidents service & nginx ingress controller with modsecurity 

```bash
./scripts/2-cleanup-incidents.sh
```

Redeploy nginx ingress controller after messing about with modsecurity and core rule set (see `app-rules-before.conf`).

```bash
./scripts/3-update-ingress.sh
```

Note: for ingress controller config changes in `ingress-controller-values.yaml`
see `# edit-start` within the yaml config. 

## Testing

Using REST Client extension in VSCode. Open file and use inline. 

```bash
client/test.http
```

## Node Stuff

### Install package

```bash
npm install
```

### Create new test data

To run the test data generator:

```bash
npm run generate-incidents
```

This will create a `db.json` file with randomly generated incidents using `faker-js`. Each incident will have:
- **id**: A unique UUID
- **createdAt**: Creation date
- **type**: Incident type from predefined list
- **title**: Generated title combining company and tech terms
- **description**: Multi-sentence description using tech-related phrases

### Call the Incident API

To call the incidents API with test data:

```bash
npm run call-incidents
```

This script will:
- Call incidents api using `axios`
- Use the `request-incidents.json` 
