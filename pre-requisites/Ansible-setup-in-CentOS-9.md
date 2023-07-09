# Configure Ansible in control node and managed node for CentOS-9

## Node Naming convention

| Host name | Used terms |
|-----------|------------|
| Ansible host | control node |
| kubernetes master | managed node |
| kubernetes worker | managed node |
------------------------------------

## Configure IP address and host name in control node for ansible

```bash
echo '<ip-addr1> <host-name1>' >> /etc/hosts
echo '<ip-addr2> <host-name2>' >> /etc/hosts
echo '<ip-addr3> <host-name3>' >> /etc/hosts
```

## Configure IP address and host name in kubernetes master node for cluster

```bash
k8s_master=<k8s-master>
ssh root@${k8s_master} "echo '<ip-addr> <k8s-master>' >> /etc/hosts"
ssh root@${k8s_master} "echo '<ip-addr> <k8s-node1>' >> /etc/hosts"
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

## Setup password for ansible user and login

Create new password

```bash
sudo passwd ansible
su - ansible
```

Or delete the password

```bash
sudo passwd -d ansible
su - ansible
```

## Generate ssh-key in control node as ansible user

```bash
ssh-keygen -f /home/ansible/.ssh/id_rsa
```

## Prepare ansible managed nodes

Commands mentioning `<k8s-host>` is required to run in all managed node.

### Create ansible user in managed node

```bash
k8s_host="<k8s-host>"
ansible_home='/home/ansible'

ssh root@${k8s_host} "useradd ansible"
ssh root@${k8s_host} "mkdir -p ${ansible_home}/.ssh"
ssh root@${k8s_host} "chmod 700 ${ansible_home}/.ssh"
ssh root@${k8s_host} "chown -R ansible:ansible ${ansible_home}/.ssh"
```

### Copy id_rsa.pub key from control node to managed nodes .ssh/authorized_keys file

```bash
k8s_host="<k8s-host>"
ansible_home='/home/ansible'

scp ${ansible_home}/.ssh/id_rsa.pub root@${k8s_host}:${ansible_home}/.ssh/id_rsa.pub
ssh root@${k8s_host} "chown ansible:ansible ${ansible_home}/.ssh/id_rsa.pub"
ssh root@${k8s_host} "tee < ${ansible_home}/.ssh/id_rsa.pub -a ${ansible_home}/.ssh/authorized_keys"
ssh root@${k8s_host} "chown ansible:ansible ${ansible_home}/.ssh/authorized_keys"
ssh root@${k8s_host} "chmod 600 ${ansible_home}/.ssh/authorized_keys"
```

### Add ansible to sudoers group for managed nodes

```bash
k8s_host="<k8s-host>"
ssh root@${k8s_host} "echo 'ansible ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/ansible"
```

### Allow ansible user to execute command remotely from control node

```bash
k8s_host="<k8s-host>"

ssh root@${k8s_host} "sed -i 's/#PubkeyAuthentication\syes/PubkeyAuthentication yes/' /etc/ssh/sshd_config"
ssh root@${k8s_host} "sed -i 's/#AuthorizedKeysFile\s.ssh\/authorized_keys/AuthorizedKeysFile .ssh\/authorized_keys/' /etc/ssh/sshd_config"
ssh root@${k8s_host} "systemctl restart sshd"
```

## Add host groups in control node for ansible user

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

Thank you.
