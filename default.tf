################################################################################
# Default Security Group
################################################################################

resource "aws_default_security_group" "this" {
  count = local.create_vpc && var.manage_default_security_group ? 1 : 0

  region = var.region

  vpc_id = aws_vpc.this[0].id

  dynamic "ingress" {
    for_each = var.default_security_group_ingress

    content {
      cidr_blocks      = ingress.value.cidr_blocks
      description      = ingress.value.description
      from_port        = ingress.value.from_port
      ipv6_cidr_blocks = ingress.value.ipv6_cidr_blocks
      prefix_list_ids  = ingress.value.prefix_list_ids
      protocol         = ingress.value.protocol
      security_groups  = ingress.value.security_groups
      self             = ingress.value.self
      to_port          = ingress.value.to_port
    }
  }

  dynamic "egress" {
    for_each = var.default_security_group_egress

    content {
      cidr_blocks      = ingress.value.cidr_blocks
      description      = ingress.value.description
      from_port        = ingress.value.from_port
      ipv6_cidr_blocks = ingress.value.ipv6_cidr_blocks
      prefix_list_ids  = ingress.value.prefix_list_ids
      protocol         = ingress.value.protocol
      security_groups  = ingress.value.security_groups
      self             = ingress.value.self
      to_port          = ingress.value.to_port
    }
  }

  tags = merge(
    var.tags,
    { Name = coalesce(var.default_security_group_name, "${var.name}-default") },
    var.default_security_group_tags,
  )
}

################################################################################
# Default Network ACLs
################################################################################

resource "aws_default_network_acl" "this" {
  count = local.create_vpc && var.manage_default_network_acl ? 1 : 0

  region = var.region

  default_network_acl_id = aws_vpc.this[0].default_network_acl_id

  # subnet_ids is using lifecycle ignore_changes, so it is not necessary to list
  # any explicitly. See https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/736
  subnet_ids = null

  dynamic "ingress" {
    for_each = var.default_network_acl_ingress

    content {
      action          = ingress.value.action
      cidr_block      = ingress.value.cidr_block
      from_port       = ingress.value.from_port
      icmp_code       = ingress.value.icmp_code
      icmp_type       = ingress.value.icmp_type
      ipv6_cidr_block = ingress.value.ipv6_cidr_block
      protocol        = ingress.value.protocol
      rule_no         = ingress.value.rule_no
      to_port         = ingress.value.to_port
    }
  }
  dynamic "egress" {
    for_each = var.default_network_acl_egress

    content {
      action          = egress.value.action
      cidr_block      = egress.value.cidr_block
      from_port       = egress.value.from_port
      icmp_code       = egress.value.icmp_code
      icmp_type       = egress.value.icmp_type
      ipv6_cidr_block = egress.value.ipv6_cidr_block
      protocol        = egress.value.protocol
      rule_no         = egress.value.rule_no
      to_port         = egress.value.to_port
    }
  }

  tags = merge(
    var.tags,
    { Name = coalesce(var.default_network_acl_name, "${var.name}-default") },
    var.default_network_acl_tags,
  )

  lifecycle {
    ignore_changes = [subnet_ids]
  }
}

################################################################################
# Default Route
################################################################################

resource "aws_default_route_table" "default" {
  count = local.create_vpc && var.manage_default_route_table ? 1 : 0

  region = var.region

  default_route_table_id = aws_vpc.this[0].default_route_table_id
  propagating_vgws       = var.default_route_table_propagating_vgws

  dynamic "route" {
    for_each = var.default_route_table_routes

    content {
      cidr_block                = route.value.cidr_block
      egress_only_gateway_id    = route.value.egress_only_gateway_id
      gateway_id                = route.value.gateway_id
      instance_id               = route.value.instance_id
      ipv6_cidr_block           = route.value.ipv6_cidr_block
      nat_gateway_id            = route.value.nat_gateway_id
      network_interface_id      = route.value.network_interface_id
      transit_gateway_id        = route.value.transit_gateway_id
      vpc_endpoint_id           = route.value.vpc_endpoint_id
      vpc_peering_connection_id = route.value.vpc_peering_connection_id
    }
  }

  timeouts {
    create = "5m"
    update = "5m"
  }

  tags = merge(
    var.tags,
    { Name = coalesce(var.default_route_table_name, "${var.name}-default") },
    var.default_route_table_tags,
  )
}
