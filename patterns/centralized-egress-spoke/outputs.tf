output "private_subnet_ids" {
  description = "Map of availability zone to workload subnet ID"
  value       = { for k, v in module.private_subnet : k => v.id }
}

output "attachment_subnet_ids" {
  description = "Map of availability zone to the /28 holding the transit gateway attachment"
  value       = { for k, v in module.attachment_subnet : k => v.id }
}

output "private_route_table_id" {
  description = "The route table sending everything to the transit gateway"
  value       = module.private_route_table.id
}

output "internet_gateway_id" {
  description = "Deliberately null: a centralized egress spoke has no internet gateway"
  value       = module.vpc.igw_id
}
