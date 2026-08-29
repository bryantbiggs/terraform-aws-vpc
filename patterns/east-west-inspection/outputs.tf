output "app_subnet_ids" {
  description = "Map of availability zone to application tier subnet ID"
  value       = { for k, v in module.app_subnet : k => v.id }
}

output "db_subnet_ids" {
  description = "Map of availability zone to database tier subnet ID"
  value       = { for k, v in module.db_subnet : k => v.id }
}

output "firewall_subnet_ids" {
  description = "Map of availability zone to firewall subnet ID"
  value       = { for k, v in module.firewall_subnet : k => v.id }
}

output "firewall_endpoint_ids" {
  description = "Map of availability zone to the firewall endpoint both tiers route through"
  value       = { for az, e in local.firewall_endpoints : az => e.endpoint_id }
}
