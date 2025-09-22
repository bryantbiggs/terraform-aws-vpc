################################################################################
# VPC
################################################################################

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc_ipam_set_netmask.id
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = module.vpc_ipam_set_netmask.arn
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc_ipam_set_netmask.cidr_block
}

output "default_security_group_id" {
  description = "The ID of the security group created by default on VPC creation"
  value       = module.vpc_ipam_set_netmask.default_security_group_id
}

output "default_network_acl_id" {
  description = "The ID of the default network ACL"
  value       = module.vpc_ipam_set_netmask.default_network_acl_id
}

output "default_route_table_id" {
  description = "The ID of the default route table"
  value       = module.vpc_ipam_set_netmask.default_route_table_id
}

output "vpc_main_route_table_id" {
  description = "The ID of the main route table associated with this VPC"
  value       = module.vpc_ipam_set_netmask.main_route_table_id
}

output "vpc_ipv6_cidr_block" {
  description = "The IPv6 CIDR block"
  value       = module.vpc_ipam_set_netmask.ipv6_cidr_block
}

output "vpc_secondary_cidr_blocks" {
  description = "List of secondary CIDR blocks of the VPC"
  value       = module.vpc_ipam_set_netmask.secondary_cidr_blocks
}

output "vpc_owner_id" {
  description = "The ID of the AWS account that owns the VPC"
  value       = module.vpc_ipam_set_netmask.owner_id
}

################################################################################
# DHCP Options Set
################################################################################

output "dhcp_options_id" {
  description = "The ID of the DHCP options"
  value       = module.vpc_ipam_set_netmask.dhcp_options_id
}

################################################################################
# Internet Gateway
################################################################################

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = module.vpc_ipam_set_netmask.internet_gateway_id
}

output "internet_gateway_arn" {
  description = "The ARN of the Internet Gateway"
  value       = module.vpc_ipam_set_netmask.internet_gateway_arn
}

################################################################################
# Public Subnets
################################################################################

output "public_subnets" {
  description = "A list of all subnets created and their attributes"
  value       = module.vpc_ipam_set_netmask.public_subnets
}

output "public_subnet_ids" {
  description = "List of IDs of public subnets"
  value       = module.vpc_ipam_set_netmask.public_subnet_ids
}

output "public_subnet_arns" {
  description = "List of ARNs of public subnets"
  value       = module.vpc_ipam_set_netmask.public_subnet_arns
}

output "public_subnet_cidr_blocks" {
  description = "List of cidr_blocks of public subnets"
  value       = module.vpc_ipam_set_netmask.public_subnet_cidr_blocks
}

output "public_subnet_ipv6_cidr_blocks" {
  description = "List of IPv6 cidr_blocks of public subnets in an IPv6 enabled VPC"
  value       = module.vpc_ipam_set_netmask.public_subnet_ipv6_cidr_blocks
}

output "public_route_table_ids" {
  description = "List of IDs of public route tables"
  value       = module.vpc_ipam_set_netmask.public_route_table_ids
}

output "public_network_acl_id" {
  description = "ID of the public network ACL"
  value       = module.vpc_ipam_set_netmask.public_network_acl_id
}

output "public_network_acl_arn" {
  description = "ARN of the public network ACL"
  value       = module.vpc_ipam_set_netmask.public_network_acl_arn
}

################################################################################
# Private Subnets
################################################################################

output "private_subnets" {
  description = "A list of all subnets created and their attributes"
  value       = module.vpc_ipam_set_netmask.private_subnets
}

output "private_subnet_ids" {
  description = "List of IDs of private subnets"
  value       = module.vpc_ipam_set_netmask.private_subnet_ids
}

output "private_subnet_arns" {
  description = "List of ARNs of private subnets"
  value       = module.vpc_ipam_set_netmask.private_subnet_arns
}

output "private_subnet_cidr_blocks" {
  description = "List of cidr_blocks of private subnets"
  value       = module.vpc_ipam_set_netmask.private_subnet_cidr_blocks
}

output "private_subnet_ipv6_cidr_blocks" {
  description = "List of IPv6 cidr_blocks of private subnets in an IPv6 enabled VPC"
  value       = module.vpc_ipam_set_netmask.private_subnet_ipv6_cidr_blocks
}

output "private_route_table_ids" {
  description = "List of IDs of private route tables"
  value       = module.vpc_ipam_set_netmask.private_route_table_ids
}

output "private_network_acl_id" {
  description = "ID of the private network ACL"
  value       = module.vpc_ipam_set_netmask.private_network_acl_id
}

output "private_network_acl_arn" {
  description = "ARN of the private network ACL"
  value       = module.vpc_ipam_set_netmask.private_network_acl_arn
}

################################################################################
# Outpost Subnets
################################################################################

output "outpost_subnets" {
  description = "A list of all subnets created and their attributes"
  value       = module.vpc_ipam_set_netmask.outpost_subnets
}

output "outpost_subnet_ids" {
  description = "List of IDs of outpost subnets"
  value       = module.vpc_ipam_set_netmask.outpost_subnet_ids
}

output "outpost_subnet_arns" {
  description = "List of ARNs of outpost subnets"
  value       = module.vpc_ipam_set_netmask.outpost_subnet_arns
}

output "outpost_subnet_cidr_blocks" {
  description = "List of cidr_blocks of outpost subnets"
  value       = module.vpc_ipam_set_netmask.outpost_subnet_cidr_blocks
}

output "outpost_subnet_ipv6_cidr_blocks" {
  description = "List of IPv6 cidr_blocks of outpost subnets in an IPv6 enabled VPC"
  value       = module.vpc_ipam_set_netmask.outpost_subnet_ipv6_cidr_blocks
}

output "outpost_network_acl_id" {
  description = "ID of the outpost network ACL"
  value       = module.vpc_ipam_set_netmask.outpost_network_acl_id
}

output "outpost_network_acl_arn" {
  description = "ARN of the outpost network ACL"
  value       = module.vpc_ipam_set_netmask.outpost_network_acl_arn
}

################################################################################
# Database Subnets
################################################################################

output "database_subnets" {
  description = "A list of all subnets created and their attributes"
  value       = module.vpc_ipam_set_netmask.database_subnets
}

output "database_subnet_ids" {
  description = "List of IDs of database subnets"
  value       = module.vpc_ipam_set_netmask.database_subnet_ids
}

output "database_subnet_arns" {
  description = "List of ARNs of database subnets"
  value       = module.vpc_ipam_set_netmask.database_subnet_arns
}

output "database_subnet_cidr_blocks" {
  description = "List of cidr_blocks of database subnets"
  value       = module.vpc_ipam_set_netmask.database_subnet_cidr_blocks
}

output "database_subnet_ipv6_cidr_blocks" {
  description = "List of IPv6 cidr_blocks of database subnets in an IPv6 enabled VPC"
  value       = module.vpc_ipam_set_netmask.database_subnet_ipv6_cidr_blocks
}

output "database_subnet_group_id" {
  description = "ID of database subnet group"
  value       = module.vpc_ipam_set_netmask.database_subnet_group_id
}

output "database_subnet_group_name" {
  description = "Name of database subnet group"
  value       = module.vpc_ipam_set_netmask.database_subnet_group_name
}

output "database_route_table_ids" {
  description = "List of IDs of database route tables"
  value       = module.vpc_ipam_set_netmask.database_route_table_ids
}

output "database_network_acl_id" {
  description = "ID of the database network ACL"
  value       = module.vpc_ipam_set_netmask.database_network_acl_id
}

output "database_network_acl_arn" {
  description = "ARN of the database network ACL"
  value       = module.vpc_ipam_set_netmask.database_network_acl_arn
}

################################################################################
# Redshift Subnets
################################################################################

output "redshift_subnets" {
  description = "A list of all subnets created and their attributes"
  value       = module.vpc_ipam_set_netmask.redshift_subnets
}

output "redshift_subnet_ids" {
  description = "List of IDs of redshift subnets"
  value       = module.vpc_ipam_set_netmask.redshift_subnet_ids
}

output "redshift_subnet_arns" {
  description = "List of ARNs of redshift subnets"
  value       = module.vpc_ipam_set_netmask.redshift_subnet_arns
}

output "redshift_subnet_cidr_blocks" {
  description = "List of cidr_blocks of redshift subnets"
  value       = module.vpc_ipam_set_netmask.redshift_subnet_cidr_blocks
}

output "redshift_subnet_ipv6_cidr_blocks" {
  description = "List of IPv6 cidr_blocks of redshift subnets in an IPv6 enabled VPC"
  value       = module.vpc_ipam_set_netmask.redshift_subnet_ipv6_cidr_blocks
}

output "redshift_subnet_group_id" {
  description = "ID of redshift subnet group"
  value       = module.vpc_ipam_set_netmask.redshift_subnet_group_id
}

output "redshift_route_table_ids" {
  description = "List of IDs of redshift route tables"
  value       = module.vpc_ipam_set_netmask.redshift_route_table_ids
}

output "redshift_network_acl_id" {
  description = "ID of the redshift network ACL"
  value       = module.vpc_ipam_set_netmask.redshift_network_acl_id
}

output "redshift_network_acl_arn" {
  description = "ARN of the redshift network ACL"
  value       = module.vpc_ipam_set_netmask.redshift_network_acl_arn
}

################################################################################
# Elasticache Subnets
################################################################################

output "elasticache_subnets" {
  description = "A list of all subnets created and their attributes"
  value       = module.vpc_ipam_set_netmask.elasticache_subnets
}

output "elasticache_subnet_ids" {
  description = "List of IDs of elasticache subnets"
  value       = module.vpc_ipam_set_netmask.elasticache_subnet_ids
}

output "elasticache_subnet_arns" {
  description = "List of ARNs of elasticache subnets"
  value       = module.vpc_ipam_set_netmask.elasticache_subnet_arns
}

output "elasticache_subnet_cidr_blocks" {
  description = "List of cidr_blocks of elasticache subnets"
  value       = module.vpc_ipam_set_netmask.elasticache_subnet_cidr_blocks
}

output "elasticache_subnet_ipv6_cidr_blocks" {
  description = "List of IPv6 cidr_blocks of elasticache subnets in an IPv6 enabled VPC"
  value       = module.vpc_ipam_set_netmask.elasticache_subnet_ipv6_cidr_blocks
}

output "elasticache_subnet_group_id" {
  description = "ID of elasticache subnet group"
  value       = module.vpc_ipam_set_netmask.elasticache_subnet_group_id
}

output "elasticache_subnet_group_name" {
  description = "Name of elasticache subnet group"
  value       = module.vpc_ipam_set_netmask.elasticache_subnet_group_name
}

output "elasticache_route_table_ids" {
  description = "List of IDs of elasticache route tables"
  value       = module.vpc_ipam_set_netmask.elasticache_route_table_ids
}

output "elasticache_network_acl_id" {
  description = "ID of the elasticache network ACL"
  value       = module.vpc_ipam_set_netmask.elasticache_network_acl_id
}

output "elasticache_network_acl_arn" {
  description = "ARN of the elasticache network ACL"
  value       = module.vpc_ipam_set_netmask.elasticache_network_acl_arn
}

################################################################################
# Intra Subnets
################################################################################

output "intra_subnets" {
  description = "A list of all subnets created and their attributes"
  value       = module.vpc_ipam_set_netmask.intra_subnets
}

output "intra_subnet_ids" {
  description = "List of IDs of intra subnets"
  value       = module.vpc_ipam_set_netmask.intra_subnet_ids
}

output "intra_subnet_arns" {
  description = "List of ARNs of intra subnets"
  value       = module.vpc_ipam_set_netmask.intra_subnet_arns
}

output "intra_subnet_cidr_blocks" {
  description = "List of cidr_blocks of intra subnets"
  value       = module.vpc_ipam_set_netmask.intra_subnet_cidr_blocks
}

output "intra_subnet_ipv6_cidr_blocks" {
  description = "List of IPv6 cidr_blocks of intra subnets in an IPv6 enabled VPC"
  value       = module.vpc_ipam_set_netmask.intra_subnet_ipv6_cidr_blocks
}

output "intra_route_table_ids" {
  description = "List of IDs of intra route tables"
  value       = module.vpc_ipam_set_netmask.intra_route_table_ids
}

output "intra_network_acl_id" {
  description = "ID of the intra network ACL"
  value       = module.vpc_ipam_set_netmask.intra_network_acl_id
}

output "intra_network_acl_arn" {
  description = "ARN of the intra network ACL"
  value       = module.vpc_ipam_set_netmask.intra_network_acl_arn
}

################################################################################
# NAT Gateway
################################################################################

output "nat_gateway_public_ips" {
  description = "List of public Elastic IPs used by the AWS NAT Gateways created"
  value       = module.vpc_ipam_set_netmask.nat_gateway_public_ips
}

output "nat_gateway_ids" {
  description = "List of NAT Gateway IDs"
  value       = module.vpc_ipam_set_netmask.nat_gateway_ids
}

output "nat_gateway_interface_ids" {
  description = "List of Network Interface IDs assigned to NAT Gateways"
  value       = module.vpc_ipam_set_netmask.nat_gateway_interface_ids
}

################################################################################
# Egress Only Gateway
################################################################################

output "egress_only_internet_gateway_id" {
  description = "The ID of the egress only Internet Gateway"
  value       = module.vpc_ipam_set_netmask.egress_only_internet_gateway_id
}

################################################################################
# Customer Gateway
################################################################################

output "customer_gateways" {
  description = "Map of Customer Gateway's created and their attributes"
  value       = module.vpc_ipam_set_netmask.customer_gateways
}

################################################################################
# VPN Gateway
################################################################################

output "vpn_gateway_id" {
  description = "The ID of the VPN Gateway"
  value       = module.vpc_ipam_set_netmask.vpn_gateway_id
}

output "vpn_gateway_arn" {
  description = "The ARN of the VPN Gateway"
  value       = module.vpc_ipam_set_netmask.vpn_gateway_arn
}

################################################################################
# VPC Flow Log
################################################################################

output "flow_log_id" {
  description = "The ID of the Flow Log resource"
  value       = module.vpc_ipam_set_netmask.flow_log_id
}

output "flow_log_destination_arn" {
  description = "The ARN of the destination for VPC Flow Logs"
  value       = module.vpc_ipam_set_netmask.flow_log_destination_arn
}

output "flow_log_cloudwatch_iam_role_arn" {
  description = "The ARN of the IAM role used when pushing logs to Cloudwatch log group"
  value       = module.vpc_ipam_set_netmask.flow_log_cloudwatch_iam_role_arn
}

output "flow_log_deliver_cross_account_role" {
  description = "The ARN of the IAM role used when pushing logs cross account"
  value       = module.vpc_ipam_set_netmask.flow_log_deliver_cross_account_role
}

################################################################################
# Static values (arguments)
################################################################################

output "azs" {
  description = "A list of availability zones specified as argument to this module"
  value       = module.vpc_ipam_set_netmask.azs
}

output "name" {
  description = "The name of the VPC specified as argument to this module"
  value       = module.vpc_ipam_set_netmask.name
}
