# check if an argument is given
if [ -z "$1" ]; then
  echo "Error: No repository name provided."
  echo "Usage: $0 <REPO_NAME>"
  exit 1
fi

REPO_NAME=$1

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

# update the yaml file with the actual repo name
APP_YAML="../confs/application.yaml"
sudo sed -i "s|https://github.com/hgrranzi/Things-of-Inception.git|https://local.gitlab.com/${REPO_NAME}.git|g" "$APP_YAML"

# apply new yaml for ArgoCD
sudo kubectl apply -f ../confs/application.yaml