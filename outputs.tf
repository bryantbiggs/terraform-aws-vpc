locals {
  redshift_route_table_ids = aws_route_table.redshift[*].id
  public_route_table_ids   = aws_route_table.public[*].id
  private_route_table_ids  = aws_route_table.private[*].id
}

################################################################################
# VPC
################################################################################

output "id" {
  description = "The ID of the VPC"
  value       = try(aws_vpc.this[0].id, null)
}

output "arn" {
  description = "The ARN of the VPC"
  value       = try(aws_vpc.this[0].arn, null)
}

output "cidr_block" {
  description = "The CIDR block of the VPC"
  value       = try(aws_vpc.this[0].cidr_block, null)
}

output "default_security_group_id" {
  description = "The ID of the security group created by default on VPC creation"
  value       = try(aws_vpc.this[0].default_security_group_id, null)
}

output "default_network_acl_id" {
  description = "The ID of the default network ACL"
  value       = try(aws_vpc.this[0].default_network_acl_id, null)
}

output "default_route_table_id" {
  description = "The ID of the default route table"
  value       = try(aws_vpc.this[0].default_route_table_id, null)
}

output "main_route_table_id" {
  description = "The ID of the main route table associated with this VPC"
  value       = try(aws_vpc.this[0].main_route_table_id, null)
}

output "ipv6_cidr_block" {
  description = "The IPv6 CIDR block"
  value       = try(aws_vpc.this[0].ipv6_cidr_block, null)
}

output "secondary_cidr_blocks" {
  description = "List of secondary CIDR blocks of the VPC"
  value       = compact(aws_vpc_ipv4_cidr_block_association.this[*].cidr_block)
}

output "owner_id" {
  description = "The ID of the AWS account that owns the VPC"
  value       = try(aws_vpc.this[0].owner_id, null)
}

################################################################################
# DHCP Options Set
################################################################################

output "dhcp_options_id" {
  description = "The ID of the DHCP options"
  value       = try(aws_vpc_dhcp_options.this[0].id, null)
}

################################################################################
# Internet Gateway
################################################################################

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = try(aws_internet_gateway.this[0].id, null)
}

output "internet_gateway_arn" {
  description = "The ARN of the Internet Gateway"
  value       = try(aws_internet_gateway.this[0].arn, null)
}

################################################################################
# Public Subnets
################################################################################

output "public_subnets" {
  description = "A list of all subnets created and their attributes"
  value       = aws_subnet.public
}

output "public_subnet_ids" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.public[*].id
}

output "public_subnet_arns" {
  description = "List of ARNs of public subnets"
  value       = aws_subnet.public[*].arn
}

output "public_subnet_cidr_blocks" {
  description = "List of cidr_blocks of public subnets"
  value       = compact(aws_subnet.public[*].cidr_block)
}

output "public_subnet_ipv6_cidr_blocks" {
  description = "List of IPv6 cidr_blocks of public subnets in an IPv6 enabled VPC"
  value       = compact(aws_subnet.public[*].ipv6_cidr_block)
}

output "public_route_table_ids" {
  description = "List of IDs of public route tables"
  value       = local.public_route_table_ids
}

output "public_network_acl_id" {
  description = "ID of the public network ACL"
  value       = try(aws_network_acl.public[0].id, null)
}

output "public_network_acl_arn" {
  description = "ARN of the public network ACL"
  value       = try(aws_network_acl.public[0].arn, null)
}

################################################################################
# Private Subnets
################################################################################

output "private_subnets" {
  description = "A list of all subnets created and their attributes"
  value       = aws_subnet.private
}

output "private_subnet_ids" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.private[*].id
}

output "private_subnet_arns" {
  description = "List of ARNs of private subnets"
  value       = aws_subnet.private[*].arn
}

output "private_subnet_cidr_blocks" {
  description = "List of cidr_blocks of private subnets"
  value       = compact(aws_subnet.private[*].cidr_block)
}

output "private_subnet_ipv6_cidr_blocks" {
  description = "List of IPv6 cidr_blocks of private subnets in an IPv6 enabled VPC"
  value       = compact(aws_subnet.private[*].ipv6_cidr_block)
}

output "private_route_table_ids" {
  description = "List of IDs of private route tables"
  value       = local.private_route_table_ids
}

output "private_network_acl_id" {
  description = "ID of the private network ACL"
  value       = try(aws_network_acl.private[0].id, null)
}

output "private_network_acl_arn" {
  description = "ARN of the private network ACL"
  value       = try(aws_network_acl.private[0].arn, null)
}

################################################################################
# Outpost Subnets
################################################################################

output "outpost_subnets" {
  description = "A list of all subnets created and their attributes"
  value       = aws_subnet.outpost
}

output "outpost_subnet_ids" {
  description = "List of IDs of outpost subnets"
  value       = aws_subnet.outpost[*].id
}

output "outpost_subnet_arns" {
  description = "List of ARNs of outpost subnets"
  value       = aws_subnet.outpost[*].arn
}

output "outpost_subnet_cidr_blocks" {
  description = "List of cidr_blocks of outpost subnets"
  value       = compact(aws_subnet.outpost[*].cidr_block)
}

output "outpost_subnet_ipv6_cidr_blocks" {
  description = "List of IPv6 cidr_blocks of outpost subnets in an IPv6 enabled VPC"
  value       = compact(aws_subnet.outpost[*].ipv6_cidr_block)
}

output "outpost_network_acl_id" {
  description = "ID of the outpost network ACL"
  value       = try(aws_network_acl.outpost[0].id, null)
}

output "outpost_network_acl_arn" {
  description = "ARN of the outpost network ACL"
  value       = try(aws_network_acl.outpost[0].arn, null)
}

################################################################################
# Database Subnets
################################################################################

output "database_subnets" {
  description = "A list of all subnets created and their attributes"
  value       = aws_subnet.database
}

output "database_subnet_ids" {
  description = "List of IDs of database subnets"
  value       = aws_subnet.database[*].id
}

output "database_subnet_arns" {
  description = "List of ARNs of database subnets"
  value       = aws_subnet.database[*].arn
}

output "database_subnet_cidr_blocks" {
  description = "List of cidr_blocks of database subnets"
  value       = compact(aws_subnet.database[*].cidr_block)
}

output "database_subnet_ipv6_cidr_blocks" {
  description = "List of IPv6 cidr_blocks of database subnets in an IPv6 enabled VPC"
  value       = compact(aws_subnet.database[*].ipv6_cidr_block)
}

output "database_subnet_group_id" {
  description = "ID of database subnet group"
  value       = try(aws_db_subnet_group.database[0].id, null)
}

output "database_subnet_group_name" {
  description = "Name of database subnet group"
  value       = try(aws_db_subnet_group.database[0].name, null)
}

output "database_route_table_ids" {
  description = "List of IDs of database route tables"
  # Refer to https://github.com/terraform-aws-modules/terraform-aws-vpc/pull/926 before changing logic
  value = length(aws_route_table.database[*].id) > 0 ? aws_route_table.database[*].id : aws_route_table.private[*].id
}

output "database_network_acl_id" {
  description = "ID of the database network ACL"
  value       = try(aws_network_acl.database[0].id, null)
}

output "database_network_acl_arn" {
  description = "ARN of the database network ACL"
  value       = try(aws_network_acl.database[0].arn, null)
}

################################################################################
# Redshift Subnets
################################################################################

output "redshift_subnets" {
  description = "A list of all subnets created and their attributes"
  value       = aws_subnet.redshift
}

output "redshift_subnet_ids" {
  description = "List of IDs of redshift subnets"
  value       = aws_subnet.redshift[*].id
}

output "redshift_subnet_arns" {
  description = "List of ARNs of redshift subnets"
  value       = aws_subnet.redshift[*].arn
}

output "redshift_subnet_cidr_blocks" {
  description = "List of cidr_blocks of redshift subnets"
  value       = compact(aws_subnet.redshift[*].cidr_block)
}

output "redshift_subnet_ipv6_cidr_blocks" {
  description = "List of IPv6 cidr_blocks of redshift subnets in an IPv6 enabled VPC"
  value       = compact(aws_subnet.redshift[*].ipv6_cidr_block)
}

output "redshift_subnet_group_id" {
  description = "ID of redshift subnet group"
  value       = try(aws_redshift_subnet_group.redshift[0].id, null)
}

output "redshift_route_table_ids" {
  description = "List of IDs of redshift route tables"
  value       = length(local.redshift_route_table_ids) > 0 ? local.redshift_route_table_ids : (var.enable_public_redshift ? local.public_route_table_ids : local.private_route_table_ids)
}

output "redshift_network_acl_id" {
  description = "ID of the redshift network ACL"
  value       = try(aws_network_acl.redshift[0].id, null)
}

output "redshift_network_acl_arn" {
  description = "ARN of the redshift network ACL"
  value       = try(aws_network_acl.redshift[0].arn, null)
}

################################################################################
# Elasticache Subnets
################################################################################

output "elasticache_subnets" {
  description = "A list of all subnets created and their attributes"
  value       = aws_subnet.elasticache
}

output "elasticache_subnet_ids" {
  description = "List of IDs of elasticache subnets"
  value       = aws_subnet.elasticache[*].id
}

output "elasticache_subnet_arns" {
  description = "List of ARNs of elasticache subnets"
  value       = aws_subnet.elasticache[*].arn
}

output "elasticache_subnet_cidr_blocks" {
  description = "List of cidr_blocks of elasticache subnets"
  value       = compact(aws_subnet.elasticache[*].cidr_block)
}

output "elasticache_subnet_ipv6_cidr_blocks" {
  description = "List of IPv6 cidr_blocks of elasticache subnets in an IPv6 enabled VPC"
  value       = compact(aws_subnet.elasticache[*].ipv6_cidr_block)
}

output "elasticache_subnet_group_id" {
  description = "ID of elasticache subnet group"
  value       = try(aws_elasticache_subnet_group.elasticache[0].id, null)
}

output "elasticache_subnet_group_name" {
  description = "Name of elasticache subnet group"
  value       = try(aws_elasticache_subnet_group.elasticache[0].name, null)
}

output "elasticache_route_table_ids" {
  description = "List of IDs of elasticache route tables"
  value       = try(coalescelist(aws_route_table.elasticache[*].id, local.private_route_table_ids), [])
}

output "elasticache_network_acl_id" {
  description = "ID of the elasticache network ACL"
  value       = try(aws_network_acl.elasticache[0].id, null)
}

output "elasticache_network_acl_arn" {
  description = "ARN of the elasticache network ACL"
  value       = try(aws_network_acl.elasticache[0].arn, null)
}

################################################################################
# Intra Subnets
################################################################################

output "intra_subnets" {
  description = "A list of all subnets created and their attributes"
  value       = aws_subnet.intra
}

output "intra_subnet_ids" {
  description = "List of IDs of intra subnets"
  value       = aws_subnet.intra[*].id
}

output "intra_subnet_arns" {
  description = "List of ARNs of intra subnets"
  value       = aws_subnet.intra[*].arn
}

output "intra_subnet_cidr_blocks" {
  description = "List of cidr_blocks of intra subnets"
  value       = compact(aws_subnet.intra[*].cidr_block)
}

output "intra_subnet_ipv6_cidr_blocks" {
  description = "List of IPv6 cidr_blocks of intra subnets in an IPv6 enabled VPC"
  value       = compact(aws_subnet.intra[*].ipv6_cidr_block)
}

output "intra_route_table_ids" {
  description = "List of IDs of intra route tables"
  value       = aws_route_table.intra[*].id
}

output "intra_network_acl_id" {
  description = "ID of the intra network ACL"
  value       = try(aws_network_acl.intra[0].id, null)
}

output "intra_network_acl_arn" {
  description = "ARN of the intra network ACL"
  value       = try(aws_network_acl.intra[0].arn, null)
}

################################################################################
# NAT Gateway
################################################################################

output "nat_gateway_public_ips" {
  description = "List of public Elastic IPs used by the AWS NAT Gateways created"
  value       = var.reuse_nat_ips ? var.external_nat_ips : aws_eip.nat[*].public_ip
}

output "nat_gateway_ids" {
  description = "List of NAT Gateway IDs"
  value       = aws_nat_gateway.this[*].id
}

output "nat_gateway_interface_ids" {
  description = "List of Network Interface IDs assigned to NAT Gateways"
  value       = aws_nat_gateway.this[*].network_interface_id
}

################################################################################
# Egress Only Gateway
################################################################################

output "egress_only_internet_gateway_id" {
  description = "The ID of the egress only Internet Gateway"
  value       = try(aws_egress_only_internet_gateway.this[0].id, null)
}

################################################################################
# Customer Gateway
################################################################################

output "customer_gateways" {
  description = "Map of Customer Gateway's created and their attributes"
  value       = aws_customer_gateway.this
}

################################################################################
# VPN Gateway
################################################################################

output "vpn_gateway_id" {
  description = "The ID of the VPN Gateway"
  value       = try(aws_vpn_gateway.this[0].id, aws_vpn_gateway_attachment.this[0].vpn_gateway_id, null)
}

output "vpn_gateway_arn" {
  description = "The ARN of the VPN Gateway"
  value       = try(aws_vpn_gateway.this[0].arn, null)
}

################################################################################
# Static values (arguments)
################################################################################

output "azs" {
  description = "A list of availability zones specified as argument to this module"
  value       = var.azs
}

output "name" {
  description = "The name of the VPC specified as argument to this module"
  value       = var.name
}
