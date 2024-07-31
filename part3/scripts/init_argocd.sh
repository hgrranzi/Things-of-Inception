#!/bin/bash

# install ArgoCD
sudo kubectl create namespace argocd
sudo kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# wait for ArgoCD to be ready
sudo kubectl wait --for=condition=available --timeout=420s deployment/argocd-server -n argocd

# apply service for port forwarding
sudo kubectl apply -f /shared/argocd-service.yaml

sudo kubectl create namespace dev
sudo kubectl apply -f /shared/application.yaml

# get password
echo "Here it is:"
sudo kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode && echo