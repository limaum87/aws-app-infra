# Elastic IP para o NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"
  tags = var.tags
}

# NAT Gateway
resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id     = var.public_subnet_id # Subnet pública onde o NAT será configurado
  tags          = var.tags
}

# Tabela de Rotas Privada associada ao NAT Gateway
resource "aws_route_table" "private" {
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id
  }

  tags = var.tags
}

# Associação da Tabela de Rotas Privada com a Subnet Privada
resource "aws_route_table_association" "private" {
  subnet_id      = var.private_subnet_id
  route_table_id = aws_route_table.private.id
}
