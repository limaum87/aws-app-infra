# ID do NAT Gateway
output "nat_gateway_id" {
  description = "ID do NAT Gateway criado"
  value       = aws_nat_gateway.this.id
}

# Elastic IP associado ao NAT Gateway
output "nat_gateway_eip" {
  description = "Elastic IP associado ao NAT Gateway"
  value       = aws_eip.nat.public_ip
}

# ID da Tabela de Rotas Privada
output "private_route_table_id" {
  description = "ID da tabela de rotas privada associada ao NAT Gateway"
  value       = aws_route_table.private.id
}