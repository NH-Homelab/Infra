#!/bin/bash

echo "Starting Minikube with ingress and mounts..."
minikube start \
  --memory 4096 \
  --driver=docker \
#   --mount \
#   --mount-string="<local>:/mnt/k8s-data" \

# echo "Enabling ingress..."
# minikube addons enable ingress
