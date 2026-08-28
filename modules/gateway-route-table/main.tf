################################################################################
# Route Table
################################################################################

resource "aws_route_table" "this" {
  count = var.create ? 1 : 0

  region = var.region

  vpc_id = var.vpc_id

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []

    content {
      create = timeouts.value.create
      update = timeouts.value.update
      delete = timeouts.value.delete
    }
  }

  tags = merge(
    var.tags,
    { Name = var.name },
    var.route_table_tags,
  )
}

################################################################################
# Routes
################################################################################

resource "aws_route" "this" {
  for_each = { for k, v in var.routes : k => v if var.create }

  region = var.region

  route_table_id = aws_route_table.this[0].id

  destination_cidr_block      = each.value.destination_ipv4_cidr_block
  destination_ipv6_cidr_block = each.value.destination_ipv6_cidr_block
  destination_prefix_list_id  = each.value.destination_prefix_list_id

  # One of the following target arguments must be supplied:
  carrier_gateway_id        = each.value.carrier_gateway_id
  core_network_arn          = each.value.core_network_arn
  egress_only_gateway_id    = each.value.egress_only_gateway_id
  gateway_id                = each.value.gateway_id
  local_gateway_id          = each.value.local_gateway_id
  nat_gateway_id            = each.value.nat_gateway_id
  network_interface_id      = each.value.network_interface_id
  transit_gateway_id        = each.value.transit_gateway_id
  vpc_endpoint_id           = each.value.vpc_endpoint_id
  vpc_peering_connection_id = each.value.vpc_peering_connection_id

  dynamic "timeouts" {
    for_each = each.value.timeouts != null ? [each.value.timeouts] : var.route_timeouts != null ? [var.route_timeouts] : []

    content {
      create = timeouts.value.create
      update = timeouts.value.update
      delete = timeouts.value.delete
    }
  }
}

################################################################################
# Gateway Association
################################################################################

# This route table is associated with a gateway and deliberately with no subnet. AWS
# requires a gateway route table to be dedicated to the gateway:
# https://docs.aws.amazon.com/vpc/latest/userguide/igw-ingress-routing.html
resource "aws_route_table_association" "this" {
  count = var.create ? 1 : 0

  region = var.region

  gateway_id     = var.gateway_id
  route_table_id = aws_route_table.this[0].id

  dynamic "timeouts" {
    for_each = var.association_timeouts != null ? [var.association_timeouts] : []

    content {
      create = timeouts.value.create
      update = timeouts.value.update
      delete = timeouts.value.delete
    }
  }
}
