# Configuring kubernetes cluster in with control plane and worker for CentOS 9

An Ansible playbook to prepare Kubernetes cluster with control plane and worker node.

## Pre-requisites

Prepare ansible connection from ansible host to control plane and workder node. You can follow this document [ansible setup](./pre-requisites/Ansible-setup-in-CentOS-9.md) to prepare the connection.

## Clone this repository to ansible home

```bash
git clone https://github.com/mohammadrony/kubernetes-cluster-setup-playbook.git
```

## Update variable in playbook

Update the control plane ip address in [kube-control-setup/vars/main.yml](./kube-control-setup/vars/main.yml) file.

## Check ansible hosts file

Check [hosts](./hosts) file for host-group and host-names with control plane and worker node host names. By default it would work as follows

```bash
[kcontrol]
kube-control

[knodes]
kube-node1
```

## Finally run the ansible-playbook as ansible user

```bash
su ansible
ansible-playbook playbook.yml
```

Thank you.
