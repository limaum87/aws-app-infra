provider "aws" {
  region  = var.region
  profile = var.profile
}

# Módulo da VPC
module "vpc" {
  source = "./modules/vpc"
  cidr_block                 = var.cidr_block
  public_subnet_cidr        = var.public_subnet_cidr
  private_subnet_cidr        = var.private_subnet_cidr
  public_availability_zone = var.public_availability_zone
  private_availability_zone  = var.private_availability_zone
  vpc_name                   = var.vpc_name
  tags = {
    Environment = "Development"
    Project     = "Terraform Example"
  }
}
# Módulo do NAT Gateway
module "nat_gateway" {
  source            = "./modules/nat_gateway"
  vpc_id            = module.vpc.vpc_id
  public_subnet_id  = module.vpc.public_subnet_id
  private_subnet_id = module.vpc.private_subnet_id
  tags              = {
    Environment = "Development"
    Project     = "Terraform Example"
  }
}

# Módulo do Security Group
module "security_group" {
  source               = "./modules/security_group"
  name                 = "allow-80"
  description          = "Allow HTTP traffic on port 80"
  vpc_id               = module.vpc.vpc_id
  ingress_from_port    = 80
  ingress_to_port      = 80
  protocol             = "tcp"
  ingress_cidr_blocks  = ["0.0.0.0/0"] # Permite para todos
  tags                 = {
    Environment = "Development"
    Project     = "Terraform Example"
  }
}

# Módulo da Instância EC2
module "ec2_instance" {
  source                    = "./modules/ec2"
  ami                       = var.ami
  instance_type             = var.instance_type
  subnet_id                 = module.vpc.private_subnet_id # Subnet privada
  associate_public_ip_address = false # Sem IP público
  key_name                  = module.key_pair.key_pair_name
  security_group_ids        = [module.security_group.security_group_id]
  tags                      = {
    Name        = "Example EC2 Instance"
    Environment = "Development"
  }
  user_data = <<-EOT
    #!/bin/bash
    sudo apt update -y
    sudo apt install nginx -y
  EOT
}

# Módulo do Key Pair
module "key_pair" {
  source     = "./modules/keypair"
  key_name   = var.key_name
  public_key = var.public_key_path # Arquivo contendo a chave pública
}

module "alb" {
  source            = "./modules/alb"
  name              = var.alb_name # Prefixo do nome do ALB
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = [module.vpc.public_subnet_id]
  instance_ids      = [module.ec2_instance.instance_id]
  tags = {
    Environment = "Development"
    Project     = "Terraform Example"
  }
}