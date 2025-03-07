output "vpc_id" {
  description = "ID da VPC criada"
  value       = module.vpc.vpc_id
}

output "public_subnet_id" {
  description = "ID da subnet pública"
  value       = module.vpc.public_subnet_id
}

output "private_subnet_id" {
  description = "ID da subnet privada"
  value       = module.vpc.private_subnet_id
}



# Output importante
output "kubernetes_master_public_ip" {
  value       = module.kubernetes_master.public_ip
  description = "IP público do nó master do Kubernetes"
}

output "kubernetes_master_private_ip" {
  value       = module.kubernetes_master.private_ip
  description = "IP privado do nó master do Kubernetes"
}

output "kubernetes_workers_private_ips" {
  value       = module.kubernetes_workers[*].private_ip
  description = "IPs privados dos nós worker do Kubernetes"
}

output "kubernetes_connection_command" {
  value       = "ssh -i ~/.ssh/sua_chave_privada ubuntu@${module.kubernetes_master.public_ip}"
  description = "Comando para conectar ao nó master via SSH"
}

output "kubernetes_dashboard_access" {
  value       = "Use: http://${module.kubernetes_master.public_ip}:30080 para acessar aplicações expostas via NodePort"
  description = "URL para acessar aplicações expostas no cluster via NodePort"
}