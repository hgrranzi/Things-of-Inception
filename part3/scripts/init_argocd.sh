#!/bin/bash

# install ArgoCD
sudo kubectl create namespace argocd
sudo kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# wait for ArgoCD to be ready
sudo kubectl wait --for=condition=available --timeout=420s deployment/argocd-server -n argocd

sudo kubectl create namespace dev
sudo kubectl apply -f /shared/application.yaml

# forward ports
sudo kubectl port-forward svc/argocd-server 8080:443 -n argocd > /dev/null 2>&1 &
sudo kubectl port-forward svc/myapp-service 8888:8888 -n dev > /dev/null 2>&1 &

# get password
echo "Here it is:"
sudo kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode && echo