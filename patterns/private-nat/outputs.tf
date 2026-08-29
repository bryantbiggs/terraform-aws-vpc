output "private_nat_gateway_ids" {
  description = "Map of availability zone to the private NAT gateway in that zone"
  value       = { for k, v in module.nat_subnet : k => v.nat_gateway_id }
}

output "private_nat_gateway_private_ips" {
  description = "Map of availability zone to the address the far side will see as the source"
  value       = { for k, v in module.nat_subnet : k => v.nat_gateway_private_ip }
}

output "nat_subnet_ids" {
  description = "Map of availability zone to the subnet holding the private NAT gateway"
  value       = { for k, v in module.nat_subnet : k => v.id }
}

output "workload_subnet_ids" {
  description = "Map of availability zone to workload subnet ID"
  value       = { for k, v in module.workload_subnet : k => v.id }
}
