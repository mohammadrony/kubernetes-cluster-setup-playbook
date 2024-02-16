#!/bin/bash
useradd ansible
passwd -d ansible
usermod -aG wheel ansible
mkdir -p /home/ansible/.ssh
chmod 700 /home/ansible/.ssh
pub_key='ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCosTmuzcpipFHNgClXxhVx5Vzo52tng89G9MA2qrfiwAmTu5YXDdM1nbJG0jjQKrtFjdmWVAo2C/IzbYlB6I56GdxjNympPh2cHBNPhTxFBx+T10sMf6Q2Nh2YRZosW9/TQopDBxI8ilsE+zPIqg2ulCdo2s6lhgVaz42MTEm7JRDJrHCeOTLc3gOoWD2vFjdhcS4n1R5sLUmfpV40Ls/U0DUfvKZpFep6gek3Qmtt/W2hfAMjK1nww+6OXdBVOfQVu2Fnd54cdzXiNd7jDhN5QSCsuLApFfwRBuXS92gLeQnT1FbHeAe/EJDgU9RcIph1n+MnsaXln0LbZgHLqEulcRvlPEuTnrdTs/eKMBs5WDOaRqoa6ngWvB6WO2wh9/VhJwrvXC9zkN8Kba5doulqhweoi0jEPeBj9akuBHTJvLXJU3G3S9ykVPZ4oIn8UBD6wsJDK6zgSZyVxeSQhNBPfyVmPtQOER6BOgo0jwScTVSdupNvnAGgVqsKUZHjAdU= ansible@dsi-Inspiron-15-5510'
echo $pub_key >> /home/ansible/.ssh/authorized_keys
chown ansible:ansible -R /home/ansible/.ssh
echo 'ansible ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/ansible
chmod 600 /home/ansible/.ssh/authorized_keys
sed -i 's/#PubkeyAuthentication\syes/PubkeyAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/#AuthorizedKeysFile\s.ssh\/authorized_keys/AuthorizedKeysFile .ssh\/authorized_keys/' /etc/ssh/sshd_config
sed -i 's/^\(#PermitRootLogin\s.*\)/PermitRootLogin yes\n\1/' /etc/ssh/sshd_config
systemctl restart sshd

# Set hostname
echo "<hostname>" > /etc/hostname
reboot now
