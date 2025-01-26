variable "region" {
  description = "Região da AWS"
  type        = string
  default     = "us-east-1"
}

variable "profile" {
  description = "Perfil AWS configurado no arquivo credentials"
  type        = string
  default     = "default"
}

variable "cidr_block" {
  description = "CIDR principal da VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR da subnet pública"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR da subnet privada"
  type        = string
  default     = "10.0.2.0/24"
}

variable "public_availability_zone" {
  description = "Zona de disponibilidade para a subnet pública"
  type        = string
  default     = "us-east-1a"
}

variable "private_availability_zone" {
  description = "Zona de disponibilidade para a subnet privada"
  type        = string
  default     = "us-east-1a"
}

variable "ami" {
  description = "ID da AMI para a instância EC2"
  type        = string
}

variable "instance_type" {
  description = "Tipo da instância EC2"
  type        = string
  default     = "t3.micro"
}



variable "key_name" {
  description = "The name of the key pair"
  type        = string
}

variable "public_key_path" {
  description = "Path to the public key file"
  type        = string
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
}

variable "alb_name" {
  description = "The name of the ALB"
  type        = string
}

