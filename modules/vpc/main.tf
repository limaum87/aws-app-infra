resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
 tags = merge(
    var.tags,
    {
      Name = var.vpc_name  # Nome da VPC
    }
  )
}

# Subnet Pública (para o ALB)
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.public_availability_zone
  tags                    = var.tags
}

# Subnet Privada (para as instâncias EC2)
resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.private_subnet_cidr
  map_public_ip_on_launch = false
  availability_zone       = var.private_availability_zone
  tags                    = var.tags
}

# Internet Gateway (para a subnet pública)
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags   = var.tags
}

# Tabela de Rotas para a subnet pública
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
  tags = var.tags
}

# Associação da Tabela de Rotas com a Subnet Pública
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

