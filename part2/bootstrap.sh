#!/bin/bash

sudo apk update
sudo apk add curl
curl -sfL https://get.k3s.io | sh -
# sleep 3

sudo kubectl apply -f /shared/app1.yaml
sudo kubectl apply -f /shared/app2.yaml
sudo kubectl apply -f /shared/app3.yaml
sudo kubectl apply -f /shared/ingress.yaml

