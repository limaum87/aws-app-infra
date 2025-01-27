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

# Public Subnets
resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.public_availability_zones[count.index]
  map_public_ip_on_launch = true
  tags = merge(
    var.tags,
    { Name = "${var.vpc_name}-public-subnet-${count.index + 1}" }
  )
}

# Private Subnets
resource "aws_subnet" "private" {
  count                   = length(var.private_subnet_cidrs)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.private_subnet_cidrs[count.index]
  availability_zone       = var.private_availability_zones[count.index]
  map_public_ip_on_launch = false
  tags = merge(
    var.tags,
    { Name = "${var.vpc_name}-private-subnet-${count.index + 1}" }
  )
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
  for_each      = { for idx, subnet_id in aws_subnet.public : idx => subnet_id.id } # Itera sobre todas as subnets públicas
  subnet_id     = each.value # Associa a cada subnet pública
  route_table_id = aws_route_table.public.id
}