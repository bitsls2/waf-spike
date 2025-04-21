#!/bin/bash

set -e  # Exit on error

# Don't forget - docker login

cd json-server

docker tag my-json-server:latest bitsls2/json-server:latest

# Create and use multi-platform builder
docker buildx create --name multiplatform --use
docker buildx inspect --bootstrap

# Build and push for multiple platforms
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t bitsls2/json-server:latest \
  --push \
  json-server/

docker buildx imagetools inspect bitsls2/json-server:latest

cd ..