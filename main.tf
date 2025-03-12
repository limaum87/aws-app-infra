provider "aws" {
  region  = var.region
  profile = var.profile
}

# Módulo da VPC
module "vpc" {
  source                     = "./modules/vpc"
  cidr_block                 = var.cidr_block
  public_subnet_cidrs        = var.public_subnet_cidrs
  public_availability_zones  = var.public_availability_zones
  private_subnet_cidrs       = var.private_subnet_cidrs
  private_availability_zones = var.private_availability_zones
  vpc_name                   = var.vpc_name
  tags                       = var.tags
}

# Módulo do NAT Gateway
module "nat_gateway" {
  source            = "./modules/nat_gateway"
  vpc_id            = module.vpc.vpc_id
  public_subnet_id  = module.vpc.public_subnet_id
  private_subnet_id = module.vpc.private_subnet_id
  tags = {
    Environment = "Development"
    Project     = "Kubernetes Cluster"
  }
}

# Security Group para o Kubernetes - Comunicação interna
module "kubernetes_sg" {
  source              = "./modules/security_group"
  name                = "kubernetes-sg"
  description         = "Security group for Kubernetes cluster internal communication"
  vpc_id              = module.vpc.vpc_id
  ingress_from_port   = 0
  ingress_to_port     = 0
  protocol            = "-1"
  ingress_cidr_blocks = [var.cidr_block] # Comunicação interna na VPC
  tags = {
    Environment = "Development"
    Project     = "Kubernetes Cluster"
  }
}

# Security Group para SSH e acesso à API do Kubernetes
module "k8s_api_ssh_sg" {
  source              = "./modules/security_group"
  name                = "k8s-api-ssh-sg"
  description         = "Allow SSH and Kubernetes API access"
  vpc_id              = module.vpc.vpc_id
  ingress_from_port   = 22
  ingress_to_port     = 22
  protocol            = "tcp"
  ingress_cidr_blocks = ["0.0.0.0/0"] # Idealmente, restrinja para seu IP em um ambiente real
  tags = {
    Environment = "Development"
    Project     = "Kubernetes Cluster"
  }
}

# Adicional Security Group Rule para a API do Kubernetes (porta 6443)
resource "aws_security_group_rule" "k8s_api" {
  security_group_id = module.k8s_api_ssh_sg.security_group_id
  type              = "ingress"
  from_port         = 6443
  to_port           = 6443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] # Idealmente, restrinja para seu IP em um ambiente real
}

# Adicional Security Group Rule para NodePort (30000-32767)
resource "aws_security_group_rule" "nodeport_range" {
  security_group_id = module.k8s_api_ssh_sg.security_group_id
  type              = "ingress"
  from_port         = 30000
  to_port           = 32767
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] # Idealmente, restrinja para seu IP em um ambiente real
}

# Módulo do Key Pair
module "key_pair" {
  source     = "./modules/keypair"
  key_name   = var.key_name
  public_key = var.public_key_path
}

# Módulo para o nó master do Kubernetes
module "kubernetes_master" {
  source                      = "./modules/ec2"
  ami                         = var.ami
  instance_type               = var.k8s_master_instance_type
  subnet_id                   = module.vpc.public_subnet_id # Subnet pública para acessibilidade
  associate_public_ip_address = true                        # IP público para acesso
  key_name                    = module.key_pair.key_pair_name
  security_group_ids          = [module.kubernetes_sg.security_group_id, module.k8s_api_ssh_sg.security_group_id]
  tags = {
    Name        = "k8s-master"
    Environment = "Development"
    Role        = "Kubernetes Master"
  }
  user_data = file("${path.module}/scripts/setup-master.sh")
}

# Módulo para os nós worker do Kubernetes
module "kubernetes_workers" {
  source                      = "./modules/ec2"
  count                       = var.k8s_worker_count
  ami                         = var.ami
  instance_type               = var.k8s_worker_instance_type
  subnet_id                   = element(module.vpc.private_subnet_ids, count.index % length(module.vpc.private_subnet_ids))
  associate_public_ip_address = false
  key_name                    = module.key_pair.key_pair_name
  security_group_ids          = [module.kubernetes_sg.security_group_id]
  tags = {
    Name        = "k8s-worker-${count.index + 1}"
    Environment = "Development"
    Role        = "Kubernetes Worker"
  }
  user_data = templatefile("${path.module}/scripts/setup-worker.sh", {
    master_ip = module.kubernetes_master.private_ip,
    token     = var.kubeadm_token,      # Aqui a variável é usada
    hash      = var.kubeadm_token_hash # Aqui a variável é usada
  })
}

# Tabela de Rotas para a subnet privada com o NAT Gateway
resource "aws_route_table" "private" {
  vpc_id = module.vpc.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = module.nat_gateway.nat_gateway_id  # Direciona para o NAT Gateway
  }

  tags = var.tags
}

# Associação da Tabela de Rotas com a Subnet Privada
resource "aws_route_table_association" "private" {
  for_each      = { for idx, subnet_id in module.vpc.private_subnet_ids : idx => subnet_id } # Itera sobre todas as subnets privadas
  subnet_id     = each.value
  route_table_id = aws_route_table.private.id
}
