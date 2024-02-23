#!/bin/bash
# Initial VM setup
sudo timedatectl set-timezone Asia/Dhaka
sudo echo "k8s-node" > /etc/hostname

# Setup new user
sudo useradd username
sudo usermod -aG wheel username
sudo echo 'username ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/username
sudo passwd username

sudo reboot now
