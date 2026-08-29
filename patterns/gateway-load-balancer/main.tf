provider "aws" {
  region = local.region
}

data "aws_availability_zones" "available" {}

locals {
  name   = "ex-${basename(path.cwd)}"
  region = "eu-west-1"

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  application_subnets = { for i, az in local.azs : az => cidrsubnet(local.vpc_cidr, 8, i + 4) }
  endpoint_subnets    = { for i, az in local.azs : az => cidrsubnet(local.vpc_cidr, 8, i + 8) }

  tags = {
    Pattern    = local.name
    GithubRepo = "terraform-aws-vpc"
    GithubOrg  = "terraform-aws-modules"
  }
}

module "vpc" {
  source = "../../"

  name = local.name
  cidr = local.vpc_cidr
  azs  = local.azs

  # composing subnets outside the module, so ask for the gateway explicitly
  create_igw = true

  tags = local.tags
}

################################################################################
# Endpoint subnets
#
# The appliance endpoints live here and nothing else does, so that the endpoint can be
# the next hop for the application subnets
################################################################################

module "endpoint_subnet" {
  source   = "../../modules/subnet"
  for_each = local.endpoint_subnets

  name              = "${local.name}-endpoint-${each.key}"
  vpc_id            = module.vpc.vpc_id
  availability_zone = each.key
  ipv4_cidr_block   = each.value

  # inspected traffic leaves through the gateway; the local route returns the rest
  routes = {
    igw = {
      destination_ipv4_cidr_block = "0.0.0.0/0"
      create_gateway_association  = true
      gateway_id                  = module.vpc.igw_id
    }
  }

  tags = local.tags
}

################################################################################
# Application subnets
#
# Outbound traffic is inspected before it leaves
################################################################################

module "application_subnet" {
  source   = "../../modules/subnet"
  for_each = local.application_subnets

  name              = "${local.name}-application-${each.key}"
  vpc_id            = module.vpc.vpc_id
  availability_zone = each.key
  ipv4_cidr_block   = each.value

  routes = {
    inspection = {
      destination_ipv4_cidr_block = "0.0.0.0/0"
      vpc_endpoint_id             = aws_vpc_endpoint.gwlb[each.key].id
    }
  }

  tags = local.tags
}

################################################################################
# Internet gateway ingress routing
#
# Inbound traffic is inspected before it reaches the application subnets. Without this
# the firewall sees only outbound traffic and the flow is asymmetric
################################################################################

module "igw_ingress" {
  source = "../../modules/route-table"

  name   = "${local.name}-igw-ingress"
  vpc_id = module.vpc.vpc_id

  gateway_id = module.vpc.igw_id

  routes = { for az, cidr in local.application_subnets :
    az => {
      destination_ipv4_cidr_block = cidr
      vpc_endpoint_id             = aws_vpc_endpoint.gwlb[az].id
    }
  }

  tags = local.tags
}

################################################################################
# Supporting Resources
################################################################################

# One endpoint per zone, into the appliance fleet's endpoint service
resource "aws_vpc_endpoint" "gwlb" {
  for_each = module.endpoint_subnet

  vpc_id            = module.vpc.vpc_id
  service_name      = var.gwlb_service_name
  vpc_endpoint_type = "GatewayLoadBalancer"
  subnet_ids        = [each.value.id]

  tags = merge(local.tags, { Name = "${local.name}-${each.key}" })
}
