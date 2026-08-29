output "vpc_id" {
  description = "The existing VPC these subnets were added to"
  value       = data.aws_vpc.existing.id
}

output "public_subnet_ids" {
  description = "Map of availability zone to the new public subnet ID"
  value       = { for k, v in module.public_subnet : k => v.id }
}

output "private_subnet_ids" {
  description = "Map of availability zone to the new private subnet ID"
  value       = { for k, v in module.private_subnet : k => v.id }
}
