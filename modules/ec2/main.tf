resource "aws_instance" "this" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  associate_public_ip_address = var.associate_public_ip_address
  key_name                    = var.key_name
  vpc_security_group_ids      = var.security_group_ids

  tags = var.tags

  # Opcional: User Data para inicialização (exemplo: instalar NGINX)
  user_data = var.user_data
}
