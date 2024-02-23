#!/bin/bash
# Delete a cluster node
NODE=''
kubectl drain $NODE --ignore-daemonsets
kubectl cordon $NODE
kubectl delete node $NODE
