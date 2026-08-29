output "vpc_cidr_block" {
  description = "The CIDR IPAM allocated to the VPC, not known until apply"
  value       = module.vpc.vpc_cidr_block
}

output "public_subnet_cidr_blocks" {
  description = "Map of availability zone to public subnet CIDR, carved from the allocation"
  value       = { for k, v in module.public_subnet : k => v.ipv4_cidr_block }
}

output "private_subnet_cidr_blocks" {
  description = "Map of availability zone to private subnet CIDR, carved from the allocation"
  value       = { for k, v in module.private_subnet : k => v.ipv4_cidr_block }
}

output "ipam_regional_pool_id" {
  description = "The regional pool the VPC CIDR was allocated from"
  value       = aws_vpc_ipam_pool.regional.id
}
