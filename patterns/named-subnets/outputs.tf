output "subnet_ids" {
  description = "Map of caller-chosen subnet name to subnet ID"
  value       = { for k, v in module.subnet : k => v.id }
}

output "subnet_cidr_blocks" {
  description = "Map of caller-chosen subnet name to IPv4 CIDR block"
  value       = { for k, v in module.subnet : k => v.ipv4_cidr_block }
}

output "eks_subnet_ids" {
  description = "Only the subnets intended for EKS, selected by name"
  value       = { for k, v in module.subnet : k => v.id if startswith(k, "eks-") }
}
