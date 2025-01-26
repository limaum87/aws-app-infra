# Saída para o ID da VPC
output "vpc_id" {
  description = "ID da VPC criada"
  value       = aws_vpc.this.id
}


# Saída para o ID do Internet Gateway
output "internet_gateway_id" {
  description = "ID do Internet Gateway associado à VPC"
  value       = aws_internet_gateway.this.id
}


# Saída para a Tabela de Rotas Pública
output "public_route_table_id" {
  description = "ID da tabela de rotas pública"
  value       = aws_route_table.public.id
}


output "public_subnet_id" {
  description = "IDs das subnets públicas"
  value       = aws_subnet.public.id # Lista com IDs das subnets públicas
}

output "private_subnet_id" {
  description = "ID da subnet privada"
  value       = aws_subnet.private.id # ID de uma única subnet privada
}