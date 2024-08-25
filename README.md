# Things of Inception

42 project <br>
Using K3d, K3s and ArgoCD with Vagrant

## Status

COMPLETED

## Description

This project is focused on getting started with Kubernetes using K3s and K3d, deploying minimal Kubernetes clusters with Vagrant, and managing applications using Argo CD for continuous deployment.
The project consists of 4 parts, each progressively introducing new tools and technique.

### Requirements

- Vagrant
- VirtualBox

### [Part 1: K3s and Vagrant](./part1)

In this part, we set up a minimal K3s cluster using Vagrant. The setup consists of two virtual machines:
- **Server (controller)**: The main machine running K3s in controller mode.
- **ServerWorker (agent)**: The second machine running K3s in agent mode.

To run:
```
cd part1/
vagrant up
```

### [Part 2: K3s and Three Simple Applications](./part2)

In this part, we deploy three simple web applications on the K3s cluster:
- Each app is accessible based on the host used during the request.
- App2 runs with three replicas for scalability.
- We configure K3s Ingress to route traffic based on the hostnames (`app1.com`, `app2.com`, etc.).

To run:
```
cd part2/
vagrant up
```

### [Part 3: K3d and Argo CD](./part3)

Here, we replace K3s with K3d, a lightweight Kubernetes distribution that runs in Docker. We set up **Argo CD** for continuous delivery, deploying an application from a GitHub repository:
- Two namespaces: `argocd` (for Argo CD) and `dev` (for the application).
- We deploy two versions of the app, demonstrating the use of tagging (`v1`, `v2`) and automatic updates via GitHub.

To run:

```
cd part3/
vagrant up
vagrant ssh testVM
cd /shared/part3/scripts
sh install_k3d.sh
sh init_argocd.sh
```

### [Part 4: GitLab Integration](./part4)

We set up a local GitLab instance within the cluster and integrate it with the configuration from Part 3.
- Add namespace `gitlab` for the GitLab instance.
- The GitLab installation is done with Helm

To run:
1. Ensure Part 3 is fully installed and configured, then:
```
vagrant ssh testVM
cd /shared/part4/scripts
sh install_gitlab.sh
```
2. Manually create a new repository in the installed local GitLab instance, then:
```
vagrant ssh testVM
cd /shared/part4/scripts
sh migrate_gitlab.sh <your-repo-name>
```