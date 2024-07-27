#!/bin/bash

# install ArgoCD
sudo kubectl create namespace argocd
sudo kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

sudo kubectl create namespace dev
sudo kubectl apply -f /shared/application.yaml

# forward port for ArgoCD UI
sudo kubectl port-forward svc/argocd-server 8080:443 -n argocd > /dev/null 2>&1 &

# wait for ArgoCD to be ready
sudo kubectl wait --for=condition=available --timeout=420s deployment/argocd-server -n argocd

# get password
echo "Here it is:"
sudo kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode && echo