#!/bin/bash

set -x

# check if an argument is given
if [ -z "$1" ]; then
  echo "Error: No repository name provided."
  echo "Usage: $0 <REPO_NAME>"
  exit 1
fi

REPO_NAME=$1

sudo rm -rf "${REPO_NAME}"

# clone destination (fresh created) repo
if ! sudo git clone http://gitlab.local.com/root/${REPO_NAME}.git; then
  echo "Error: There is no repo with the name ${REPO_NAME} in GitLab, please provide an existing repo name"
  exit 1
fi

# clone source repo
sudo git clone https://github.com/hgrranzi/Things-of-Inception.git
sudo mv Things-of-Inception/dev ${REPO_NAME}/
sudo rm -rf Things-of-Inception

cd "${REPO_NAME}" || {
  echo "Error: Failed to navigate to the repository directory ${REPO_NAME}"
  exit 1
}

sudo git add .
sudo git commit -m "migrated"
sudo git push

cd ..

# update the yaml file with the actual repo name
sudo sed -i "s|http://[^ ]*.git|http://gitlab-webservice-default.gitlab:8181/root/${REPO_NAME}.git|" ../confs/application.yaml

# apply new yaml for ArgoCD todo: debug, does not find path
sudo kubectl apply -f ../confs/application.yaml