output "nat_gateway_id" {
  description = "The single NAT gateway serving the whole VPC"
  value       = module.public_subnet[local.nat_zone].nat_gateway_id
}

output "public_subnet_ids" {
  description = "Map of availability zone to public subnet ID"
  value       = { for k, v in module.public_subnet : k => v.id }
}

output "private_subnet_ids" {
  description = "Map of availability zone to private subnet ID"
  value       = { for k, v in module.private_subnet : k => v.id }
}

output "private_route_table_id" {
  description = "The single route table shared by every private subnet"
  value       = module.private_route_table.id
}
