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
echo '<ip-addr2> vm-master' >> /etc/hosts
echo '<ip-addr3> vm-worker' >> /etc/hosts
```

Configure IP address and host name in kubernetes master node

```bash
ssh root@vm-master
echo 'vm-master' >> /etc/hostname
echo '<ip-addr2> vm-master' >> /etc/hosts
echo '<ip-addr3> vm-worker' >> /etc/hosts
reboot now
```

Configure IP address and host name in kubernetes worker node

```bash
ssh root@vm-worker
echo 'vm-worker' >> /etc/hostname
echo '<ip-addr2> vm-master' >> /etc/hosts
echo '<ip-addr3> vm-worker' >> /etc/hosts
reboot now
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

Commands mentioning `kube_host` are required to run on all managed nodes. i.e., `vm-master` and `vm-worker`.

Login to ansible managed node

```bash
ssh root@<kube-host>
```

Create ansible user in managed node

```bash
useradd ansible
mkdir -p /home/ansible/.ssh
chmod 700 /home/ansible/.ssh
chown -R ansible:ansible /home/ansible/.ssh
```

Copy public key from ansible control node to managed nodes

```bash
cat /home/ansible/.ssh/id_rsa.pub
```

```bash
ansible_home='/home/ansible'
chown ansible:ansible /home/ansible/.ssh/id_rsa.pub
tee < /home/ansible/.ssh/id_rsa.pub -a /home/ansible/.ssh/authorized_keys
chown ansible:ansible /home/ansible/.ssh/authorized_keys
chmod 600 /home/ansible/.ssh/authorized_keys
```

Add ansible to sudoers group in managed nodes

```bash
echo 'ansible ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/ansible
```

Allow public key connection for user

```bash
sed -i 's/#PubkeyAuthentication\syes/PubkeyAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/#AuthorizedKeysFile\s.ssh\/authorized_keys/AuthorizedKeysFile .ssh\/authorized_keys/' /etc/ssh/sshd_config
systemctl restart sshd
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
```
