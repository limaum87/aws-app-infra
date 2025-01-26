variable "vpc_id" {
  description = "ID da VPC onde o NAT Gateway será criado"
  type        = string
}

variable "public_subnet_id" {
  description = "ID da subnet pública onde o NAT Gateway será criado"
  type        = string
}

variable "private_subnet_id" {
  description = "ID da subnet privada associada ao NAT Gateway"
  type        = string
}

variable "tags" {
  description = "Tags para os recursos criados"
  type        = map(string)
}