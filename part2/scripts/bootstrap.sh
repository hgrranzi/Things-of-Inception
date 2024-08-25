#!/bin/bash

sudo apk update
sudo apk add curl
curl -sfL https://get.k3s.io | sh -

check_kubectl() {
    for i in {1..30}; do
        if kubectl cluster-info >/dev/null 2>&1; then
            echo "kubectl is working."
            return 0
        fi
        echo "Waiting kubectl being ready... ($i/30)"
        sleep 10
    done
    echo "Erro: kubectl not working after 5 minutes"
    exit 1
}

# Check kubectl
check_kubectl

sudo kubectl apply -f /shared/confs/app1.yaml
sudo kubectl apply -f /shared/confs/app2.yaml
sudo kubectl apply -f /shared/confs/app3.yaml
sudo kubectl apply -f /shared/confs/ingress.yaml