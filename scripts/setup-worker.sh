#!/bin/bash

# Atualizar pacotes do sistema
sudo apt-get update -y
sudo apt-get upgrade -y

# Instalar pacotes necessários
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Adicionar a chave do repositório do Kubernetes
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

# Adicionar o repositório do Kubernetes
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Atualizar a lista de pacotes
sudo apt-get update -y

# Instalar Kubernetes (kubelet, kubeadm, kubectl)
sudo apt-get install -y kubelet kubeadm kubectl

# Marcar as versões para não serem atualizadas automaticamente
sudo apt-mark hold kubelet kubeadm kubectl

# Desabilitar o swap (necessário para o Kubernetes)
sudo swapoff -a
sudo sed -i '/swap/d' /etc/fstab

# Comando para adicionar o nó worker ao cluster
sudo kubeadm join ${master_ip}:6443 --token ${token} --discovery-token-ca-cert-hash sha256:${hash}

# Iniciar e habilitar o kubelet
sudo systemctl enable kubelet
sudo systemctl start kubelet

# Verificar status do kubelet
sudo systemctl status kubelet
