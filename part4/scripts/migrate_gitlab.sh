# install helm
sudo curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
sudo bash get_helm.sh

# create namespace gitlab
sudo kubectl create namespace gitlab

# install gitlab with helm
sudo helm repo add gitlab https://charts.gitlab.io
sudo helm repo update

sudo helm install gitlab gitlab/gitlab \
  --timeout 900s \
  --namespace gitlab \
  --version 7.2.0 \
  --set global.hosts.domain=local.com \
  --set certmanager-issuer.email=iot@example.com \
  --set global.hosts.https="false" \
  --set gitlab-runner.install="false" \
  --debug

# waiting for gitlab to be ready
sudo kubectl wait --for=condition=available --timeout=1800s deployment/gitlab-webservice-default -n gitlab

# forward gitlab ports or apply service (could be cleaner)
sudo kubectl port-forward svc/gitlab-webservice-default -n gitlab 8181:8181 --address="0.0.0.0" >/dev/null 2>&1 &

# todo: clone repo from github or create it

# todo: apply new yaml for ArgoCD

# get gitlab password
echo "Here it is:"
sudo kubectl get secret gitlab-gitlab-initial-root-password -ojsonpath='{.data.password}' -n gitlab | base64 --decode ; echo