variable "cidr_block" {
  description = "CIDR da VPC"
}

variable "public_subnet_cidr" {
  description = "CIDR para a subnet pública"
}

variable "private_subnet_cidr" {
  description = "CIDR para a subnet privada"
}

variable "public_availability_zone" {
  description = "Zona de disponibilidade para a subnet pública"
}

variable "private_availability_zone" {
  description = "Zona de disponibilidade para a subnet privada"
}

variable "tags" {
  description = "Tags para os recursos"
  type        = map(string)
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
}

