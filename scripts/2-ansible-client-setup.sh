#!/bin/bash
# Ansible client setup
USER=ansible
useradd $USER
passwd -d $USER
usermod -aG wheel $USER
echo "$USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USER
sed -i "s/#PubkeyAuthentication\syes/PubkeyAuthentication yes/" /etc/ssh/sshd_config
sed -i "s/#AuthorizedKeysFile\s.ssh\/authorized_keys/AuthorizedKeysFile .ssh\/authorized_keys/" /etc/ssh/sshd_config
sed -i "s/^\(#PermitRootLogin\s.*\)/PermitRootLogin yes\n\1/" /etc/ssh/sshd_config
systemctl restart sshd
