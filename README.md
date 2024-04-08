# Configure Kubernetes cluster in CentOS 9

An Ansible playbook to prepare Kubernetes cluster with control plane and worker node.

## Pre-requisites

Prepare ansible connection from ansible host to control plane and worker node. You can follow this document [ansible setup](./pre-requisites/Ansible-setup-in-CentOS.md) to prepare the connection.

## Clone this repository

```bash
su - ansible
git clone https://github.com/mohammadrony/kubernetes-cluster-setup-playbook.git
```

## Update variable in playbook

Update the variables in [kube control setup](./kube-control-setup/vars/main.yml), [kube node setup](./kube-node-setup/vars/main.yml) and [post installation](./post-installation/vars/main.yml) role.

## Check ansible hosts file

Check [hosts](./hosts) file for host-group and host-names with control plane and worker node host names. By default it would work as follows

```bash
[kcontrol]
vm-master

[knodes]
vm-worker
```

## Run Ansible playbook

```bash
ansible-playbook playbook.yml
```

## Access Kubernetes cluster from remote host

- Find the config file for the cluster from Ansible control host's `/home/ansible/kubeconfig` file.
- Copy the config file to remote host's `~/.kube/config` file.

Thank you.
