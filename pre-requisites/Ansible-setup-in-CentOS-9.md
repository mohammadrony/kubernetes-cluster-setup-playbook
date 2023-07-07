# Configure Ansible in control node and managed node for CentOS-9

## Node Naming convention

| Host name | Used terms |
|-----------|------------|
| Ansible host | control node |
| kubernetes master | master node, managed node |
| kubernetes worker | worker node, managed node |
-------------------------------------------------

## Configure IP address and host name in control node for ansible

```bash
echo '<ip-addr> <host-name1>' >> /etc/hosts
echo '<ip-addr> <host-name2>' >> /etc/hosts
```

## Configure IP address and host name in k8s master node for cluster

```bash
ssh root@<k8s-master> "echo '<ip-addr> <k8s-host1>' >> /etc/hosts"
ssh root@<k8s-master> "echo '<ip-addr> <k8s-host2>' >> /etc/hosts"
```

## Install Ansible in control node

```bash
sudo dnf install -y epel-release
sudo dnf install -y ansible
```

## Create ansible user in control node

```bash
sudo useradd ansible
```

## Delete ansible user password and login as ansible

```bash
sudo passwd -d ansible
su - ansible
```

## Generate ssh-key in control node as ansible user

```bash
ssh-keygen -f /home/ansible/.ssh/id_rsa
```

## Prepare ansible client nodes

### Create ansible user in master node and worker node

```bash
ssh root@<k8s-host> "ansible_home='/home/ansible'"
ssh root@<k8s-host> "useradd ansible"
ssh root@<k8s-host> "mkdir -p ${ansible_home}/.ssh"
ssh root@<k8s-host> "chmod 700 ${ansible_home}/.ssh"
ssh root@<k8s-host> "chown -R ansible:ansible ${ansible_home}/.ssh"
```

### Copy id_rsa.pub key to master node and worker node's .ssh/authorized_keys file

```bash
ssh root@<k8s-host> "ansible_home='/home/ansible'"
scp ${ansible_home}/.ssh/id_rsa.pub root@<k8s-host>:${ansible_home}/.ssh/id_rsa.pub
ssh root@<k8s-host> "chown ansible:ansible ${ansible_home}/.ssh/id_rsa.pub"
ssh root@<k8s-host> "tee < ${ansible_home}/.ssh/id_rsa.pub -a ${ansible_home}/.ssh/authorized_keys"
ssh root@<k8s-host> "chown ansible:ansible ${ansible_home}/.ssh/authorized_keys"
ssh root@<k8s-host> "chmod 600 ${ansible_home}/.ssh/authorized_keys"
```

### Add ansible to sudoers group in master node and worker node

```bash
ssh root@<k8s-host> "echo 'ansible ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/ansible"
```

### Allow ansible user to execute command through remotely from control node

```bash
ssh root@<k8s-host> "sed -i 's/#PubkeyAuthentication\syes/PubkeyAuthentication yes/' /etc/ssh/sshd_config"
ssh root@<k8s-host> "sed -i 's/#AuthorizedKeysFile\s.ssh\/authorized_keys/AuthorizedKeysFile .ssh\/authorized_keys/' /etc/ssh/sshd_config"
ssh root@<k8s-host> "systemctl restart sshd"
```

## Add host groups in control node for ansible

```bash
sudo tee -a /etc/ansible/hosts << EOF
[<hostgroup1>]
<host-name-1>

[<hostgroup2>]
<host-name-2>
EOF
```

## Verify the connection is established between control node and managed node

```bash
ansible all -m ping
```
