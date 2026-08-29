output "shared_route_table_id" {
  description = "The one route table every shared subnet is associated with"
  value       = module.shared_route_table.id
}

output "shared_subnet_route_table_ids" {
  description = "Route table per shared subnet, which is the same ID three times"
  value       = { for k, v in module.shared_subnet : k => v.route_table_id }
}

output "per_az_route_table_ids" {
  description = "Route table per subnet, which is three distinct IDs"
  value       = { for k, v in module.per_az_subnet : k => v.route_table_id }
}
