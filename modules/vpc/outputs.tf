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

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = aws_subnet.private[*].id
}

# Exporta apenas o primeiro ID da subnet pública (se necessário)
output "public_subnet_id" {
  description = "ID of the first public subnet"
  value       = aws_subnet.public[0].id
}

# Exporta apenas o primeiro ID da subnet privada (se necessário)
output "private_subnet_id" {
  description = "ID of the first private subnet"
  value       = aws_subnet.private[0].id
}