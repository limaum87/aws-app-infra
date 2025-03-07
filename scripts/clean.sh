#!/bin/bash

# Step 1: Reset Kubernetes
echo "Resetting Kubernetes with kubeadm..."
sudo kubeadm reset -f

# Step 2: Remove Kubernetes configurations
echo "Removing Kubernetes configurations..."
sudo rm -rf /etc/kubernetes/
rm -rf $HOME/.kube

# Step 3: Remove Docker containers and images (if Docker is used)
echo "Removing Docker containers and images..."
sudo docker stop $(sudo docker ps -a -q)  # Stop all running containers
sudo docker rm $(sudo docker ps -a -q)    # Remove all containers
sudo docker rmi $(sudo docker images -q)  # Remove all images

# Step 4: Clean containerd configurations (if containerd is used)
echo "Cleaning containerd configurations..."
sudo systemctl stop containerd
sudo rm -rf /var/lib/containerd/*
sudo rm -rf /var/lib/kubelet/*

# Step 5: Disable swap (if Kubernetes reset hasn't already disabled it)
echo "Disabling swap..."
sudo swapoff -a
sudo sed -i '/swap/d' /etc/fstab

