# Setup Ansible in CentOS-9

## Client Node setup

### Add ansible to sudoers group for managed nodes

```bash
USER=user
sudo usermod -aG wheel $USER 
sudo echo "$USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USER
```

### Allow connection from remote server

```bash
sed -i 's/#PubkeyAuthentication\syes/PubkeyAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/#AuthorizedKeysFile\s.ssh\/authorized_keys/AuthorizedKeysFile .ssh\/authorized_keys/' /etc/ssh/sshd_config
systemctl restart sshd
```

## Control Node setup

### Install Ansible in control node

```bash
sudo dnf install -y epel-release
sudo dnf install -y ansible
```

### Generate ssh-key and copy in client node

```bash
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519
```

```bash
ssh-copy-id user@host
```

### Add host groups

```bash
sudo tee -a /etc/ansible/hosts << EOF
[<hostgroup1>]
<host1>

[<hostgroup2>]
<host2>
<host3>
EOF
```

## Test the connection

```bash
ansible all -m ping
```
