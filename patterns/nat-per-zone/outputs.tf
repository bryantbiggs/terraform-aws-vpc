output "public_subnet_ids" {
  description = "Map of availability zone to public subnet ID"
  value       = { for k, v in module.public_subnet : k => v.id }
}

output "public_route_table_id" {
  description = "The single route table shared by every public subnet"
  value       = module.public_route_table.id
}

output "nat_gateway_ids" {
  description = "Map of availability zone to the NAT gateway serving that zone"
  value       = { for k, v in module.public_subnet : k => v.nat_gateway_id }
}

output "private_subnet_ids" {
  description = "Map of availability zone to private subnet ID"
  value       = { for k, v in module.private_subnet : k => v.id }
}

output "private_route_table_ids" {
  description = "Map of availability zone to route table ID, one per private subnet"
  value       = { for k, v in module.private_subnet : k => v.route_table_id }
}
