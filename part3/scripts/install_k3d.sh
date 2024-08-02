#!/bin/bash

sudo apt update -y
sudo apt install curl -y

# install docker
sudo curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

#install kubectl
sudo curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# install k3d
sudo curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

#create cluster with port forwarding from docker to localhost
sudo k3d cluster create mycluster -p "8080:30007@server:0" -p "8888:30008@server:0"
