#!/bin/bash

# Atualizar pacotes do sistema
sudo apt-get update -y
sudo apt-get upgrade -y

# Instalar pacotes necessários para repositórios seguros e o curl
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common gnupg

# Criar o diretório de keyrings, necessário para versões mais antigas do Ubuntu (se não existir)
sudo mkdir -p /etc/apt/keyrings

# Adicionar a chave pública para o repositório Kubernetes
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# Adicionar o repositório do Kubernetes (repositório comunitário)
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Atualizar a lista de pacotes
sudo apt-get update -y

# Instalar Kubernetes (kubelet, kubeadm, kubectl)
sudo apt-get install -y kubelet kubeadm kubectl

# Marcar as versões para não serem atualizadas automaticamente
sudo apt-mark hold kubelet kubeadm kubectl

# Instalar e iniciar o containerd (runtime de contêiner)
sudo apt-get install -y containerd
sudo systemctl start containerd
sudo systemctl enable containerd

sudo modprobe bridge

# Carregar o módulo 'br_netfilter' para manipulação de tráfego de rede entre contêineres
sudo modprobe br_netfilter

# Configurar parâmetros do sistema (necessário para o Kubernetes)
echo "1" | sudo tee /proc/sys/net/bridge/bridge-nf-call-iptables
echo "net.bridge.bridge-nf-call-iptables = 1" | sudo tee -a /etc/sysctl.conf
echo "1" | sudo tee /proc/sys/net/ipv4/ip_forward
echo "net.ipv4.ip_forward = 1" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
                               
