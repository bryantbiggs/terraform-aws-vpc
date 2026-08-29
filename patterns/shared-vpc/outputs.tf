output "resource_share_arn" {
  description = "The RAM resource share the application subnets are shared through"
  value       = aws_ram_resource_share.this.arn
}

output "shared_subnet_ids" {
  description = "Map of team subnet name to subnet ID, usable by participant accounts"
  value       = { for k, v in module.app_subnet : k => v.id }
}

output "owner_only_subnet_id" {
  description = "The egress subnet, deliberately not shared"
  value       = module.public_subnet.id
}
