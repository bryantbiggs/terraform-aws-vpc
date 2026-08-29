output "private_route_table_id" {
  description = "The route table carrying all four routes"
  value       = module.private_route_table.id
}

output "routes" {
  description = "Map of route keys to the route resources created, showing the key is the address"
  value       = keys(module.private_route_table.routes)
}

output "private_subnet_ids" {
  description = "Map of availability zone to private subnet ID"
  value       = { for k, v in module.private_subnet : k => v.id }
}
