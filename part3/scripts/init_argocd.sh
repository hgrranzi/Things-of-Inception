#!/bin/bash

# create namespaces
sudo kubectl create namespace argocd
sudo kubectl create namespace dev

# apply ArgoCD
sudo kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# wait for ArgoCD to be ready
sudo kubectl wait --for=condition=available --timeout=420s deployment/argocd-server -n argocd

# apply node port service for ArgoCD port forwarding
sudo kubectl apply -f ../confs/argocd-service.yaml

# apply application deployment
sudo kubectl apply -f ../confs/application.yaml

# get ArgoCD password
echo "Here it is:"
sudo kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode && echo