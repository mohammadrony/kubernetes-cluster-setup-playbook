#!/bin/bash
useradd ansible
passwd -d ansible
mkdir -p /home/ansible/.ssh
chmod 700 /home/ansible/.ssh
echo "<ssh-public-key>" >> /home/ansible/.ssh/authorized_keys
chown ansible:ansible -R /home/ansible/.ssh
echo 'ansible ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/ansible
chmod 600 /home/ansible/.ssh/authorized_keys
sed -i 's/#PubkeyAuthentication\syes/PubkeyAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/#AuthorizedKeysFile\s.ssh\/authorized_keys/AuthorizedKeysFile .ssh\/authorized_keys/' /etc/ssh/sshd_config
sed -i 's/^\(#PermitRootLogin\s.*\)/PermitRootLogin yes\n\1/' /etc/ssh/sshd_config
systemctl restart sshd

# Set hostname
echo "<ansible-client>" > /etc/hostname
reboot now


