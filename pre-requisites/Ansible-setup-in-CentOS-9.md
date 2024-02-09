# Setup Ansible in control node and managed node in CentOS-9

## Node Naming convention

| Host name | Used terms |
|-----------|------------|
| Ansible host | control node |
| kubernetes master | managed node |
| kubernetes worker | managed node |
------------------------------------

## Hostname configuration

Configure IP address and host name in control node for ansible

```bash
echo '<ip-addr1> <ansible-host>' >> /etc/hosts
echo '<ip-addr2> kube-control' >> /etc/hosts
echo '<ip-addr3> kube-node1' >> /etc/hosts
```

Configure IP address and host name in kubernetes master node

```bash
kube_control="<ip-addr2>"
ssh root@${kube_control} "echo 'kube-control' >> /etc/hostname"
ssh root@${kube_control} "echo '<ip-addr2> kube-control' >> /etc/hosts"
ssh root@${kube_control} "echo '<ip-addr3> kube-node1' >> /etc/hosts"
ssh root@${kube_control} "reboot now"
```

Configure IP address and host name in kubernetes worker node

```bash
kube_node1="<ip-addr3>"
ssh root@${kube_node1} "echo 'kube-node1' >> /etc/hostname"
ssh root@${kube_node1} "echo '<ip-addr2> kube-control' >> /etc/hosts"
ssh root@${kube_node1} "echo '<ip-addr3> kube-node1' >> /etc/hosts"
ssh root@${kube_node1} "reboot now"
```

## Ansible control node setup

Install packages

```bash
sudo dnf install -y epel-release
sudo dnf install -y ansible
```

Create ansible user in control node

```bash
sudo useradd ansible
```

Setup password for ansible user

Create new password

```bash
sudo passwd ansible
```

Or delete the password

```bash
sudo passwd -d ansible
```

Generate ssh-key in control node

```bash
su - ansible
ssh-keygen -f /home/ansible/.ssh/id_rsa
```

## Ansible managed nodes setup

Commands mentioning `kube_host` are required to run on all managed nodes. i.e., `kube-control` and `kube-node1`.

Create ansible user in managed node

```bash
kube_host="<kube-host>"
ansible_home='/home/ansible'

ssh root@${kube_host} "useradd ansible"
ssh root@${kube_host} "mkdir -p ${ansible_home}/.ssh"
ssh root@${kube_host} "chmod 700 ${ansible_home}/.ssh"
ssh root@${kube_host} "chown -R ansible:ansible ${ansible_home}/.ssh"
```

Copy public key to .ssh/authorized_keys files in managed nodes

```bash
kube_host="<k8s-host>"
ansible_home='/home/ansible'

scp ${ansible_home}/.ssh/id_rsa.pub root@${kube_host}:${ansible_home}/.ssh/id_rsa.pub
ssh root@${kube_host} "chown ansible:ansible ${ansible_home}/.ssh/id_rsa.pub"
ssh root@${kube_host} "tee < ${ansible_home}/.ssh/id_rsa.pub -a ${ansible_home}/.ssh/authorized_keys"
ssh root@${kube_host} "chown ansible:ansible ${ansible_home}/.ssh/authorized_keys"
ssh root@${kube_host} "chmod 600 ${ansible_home}/.ssh/authorized_keys"
```

Add ansible to sudoers group in managed nodes

```bash
kube_host="<k8s-host>"
ssh root@${kube_host} "echo 'ansible ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/ansible"
```

Allow public key connection for user

```bash
kube_host="<k8s-host>"

ssh root@${kube_host} "sed -i 's/#PubkeyAuthentication\syes/PubkeyAuthentication yes/' /etc/ssh/sshd_config"
ssh root@${kube_host} "sed -i 's/#AuthorizedKeysFile\s.ssh\/authorized_keys/AuthorizedKeysFile .ssh\/authorized_keys/' /etc/ssh/sshd_config"
ssh root@${kube_host} "systemctl restart sshd"
```

## Create Host groups

```bash
sudo tee -a /etc/ansible/hosts << EOF
[<hostgroup1>]
<host-name-1>

[<hostgroup2>]
<host-name-2>
EOF
```

## Verify the connection

```bash
ansible all -m ping
```

## Remove ansible

```bash
sudo userdel ansible
sudo rm /home/ansible -rf
sudo rm /etc/sudoers.d/ansible -f
