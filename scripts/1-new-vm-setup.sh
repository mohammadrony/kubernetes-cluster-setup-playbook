#!/bin/bash
# Time and hostname setup
sudo timedatectl set-timezone Asia/Dhaka
sudo echo "k8s-node" > /etc/hostname

# Update k8s hosts
# Replace (nnn.nnn.nnn.nnn) with ip address
sudo echo "nnn.nnn.nnn.nnn k8s-master" >> /etc/hosts
sudo echo "nnn.nnn.nnn.nnn k8s-worker-1" >> /etc/hosts
sudo echo "nnn.nnn.nnn.nnn k8s-worker-N" >> /etc/hosts

# Setup new user
sudo useradd username
sudo usermod -aG wheel username
sudo echo 'username ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/username
sudo passwd username

sudo reboot now
