# install helm
sudo curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
sudo bash get_helm.sh

# create namespace gitlab
sudo kubectl create namespace gitlab

# install gitlab with helm
sudo helm repo add gitlab https://charts.gitlab.io
sudo helm repo update

sudo helm upgrade --install gitlab gitlab/gitlab \
  --timeout 900s \
  --namespace gitlab \
  --version 7.2.0 \
  -f ../confs/gitlab-values.yaml \
  --debug

# add gitlab domain to hosts
sudo echo "127.0.0.1 gitlab.local.com" | sudo tee -a "/etc/hosts" > /dev/null

# waiting for gitlab to be ready
sudo kubectl wait --for=condition=available --timeout=1800s deployment/gitlab-webservice-default -n gitlab

# forward gitlab ports or apply service (could be cleaner)
sudo kubectl port-forward svc/gitlab-webservice-default -n gitlab 80:8181 --address="0.0.0.0" >/dev/null 2>&1 &

# get gitlab password
GITLAB_PASSWORD=$(sudo kubectl get secret gitlab-gitlab-initial-root-password -n gitlab -o jsonpath="{.data.password}" | base64 --decode)

# save gitlab credentials
echo "machine gitlab.local.com
login root
password ${GITLAB_PASSWORD}" | sudo tee /root/.netrc > /dev/null
sudo chmod 600 /root/.netrc

# print gitlab password
echo "Here it is:"
echo "${GITLAB_PASSWORD}"