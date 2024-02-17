#!/bin/bash
# Reset k8s node
NODE=''
kubectl drain $NODE --ignore-daemonsets
kubectl cordon $NODE
kubectl delete node $NODE
