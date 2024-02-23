#!/bin/bash
# Reset k8s node
sudo kubeadm reset -f
sudo rm -rf /etc/cni/net.d
sudo systemctl restart containerd
