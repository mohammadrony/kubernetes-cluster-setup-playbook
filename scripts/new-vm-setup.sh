#!/bin/bash
# Setup new user
useradd username
usermod -aG wheel username
echo "<hostname>" > /etc/hostname
sudo timedatectl set-timezone Asia/Dhaka
echo 'username ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/username
passwd username

reboot now
