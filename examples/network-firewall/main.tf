provider "aws" {
  region = local.region
}

data "aws_availability_zones" "available" {}

locals {
  name   = "ex-${basename(path.cwd)}"
  region = "eu-west-1"

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  public_subnets   = zipmap(["a", "b", "c"], [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 4)])
  firewall_subnets = zipmap(["a", "b", "c"], [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 8)])

  tags = {
    Example    = local.name
    GithubRepo = "terraform-aws-vpc"
    GithubOrg  = "terraform-aws-modules"
  }
}

################################################################################
# VPC
################################################################################

module "vpc" {
  source = "../../"

  name = local.name
  cidr = local.vpc_cidr

  azs             = local.azs
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]

  tags = local.tags
}

################################################################################
# Internet Gateway
################################################################################

# The VPC module creates an internet gateway only when it is also managing public
# subnets. This example composes its own public subnets through the subnet sub-module,
# so it owns the gateway as well
resource "aws_internet_gateway" "this" {
  vpc_id = module.vpc.vpc_id

  tags = merge(local.tags, { Name = local.name })
}

################################################################################
# Subnet(s)
################################################################################

locals {
  firewall_endpoints = {
    for s in flatten(module.network_firewall.status[*].sync_states) : s.availability_zone => {
      subnet_id   = s.attachment[0].subnet_id
      endpoint_id = s.attachment[0].endpoint_id
    }
  }
}

module "public_subnet" {
  source = "../../modules/subnet"

  for_each = { for k, v in local.public_subnets :
    "${local.region}${k}" => {
      ipv4_cidr_block = v
    }
  }

  name   = "${local.name}-public-${each.key}"
  vpc_id = module.vpc.vpc_id

  availability_zone = each.key
  ipv4_cidr_block   = each.value.ipv4_cidr_block

  routes = {
    firewall-endpoint = {
      destination_ipv4_cidr_block = "0.0.0.0/0"
      vpc_endpoint_id             = local.firewall_endpoints[each.key].endpoint_id
    }
  }

  tags = local.tags
}

module "firewall_subnet" {
  source = "../../modules/subnet"

  for_each = { for k, v in local.firewall_subnets :
    "${local.region}${k}" => {
      ipv4_cidr_block = v
    }
  }

  name   = "${local.name}-firewall-${each.key}"
  vpc_id = module.vpc.vpc_id

  availability_zone = each.key
  ipv4_cidr_block   = each.value.ipv4_cidr_block

  routes = {
    igw = {
      destination_ipv4_cidr_block = "0.0.0.0/0"
      gateway_id                  = aws_internet_gateway.this.id
    }
  }

  tags = local.tags
}

################################################################################
# Internet Gateway Ingress Routing
################################################################################

# Without this, inbound traffic goes straight from the internet gateway into the public
# subnets and never reaches the firewall, while outbound traffic does. The firewall then
# sees only one direction of every connection, which a stateful engine cannot evaluate.
#
# AWS requires this route table to be dedicated to the gateway and associated with no
# subnet, so the subnet sub-module cannot create it: that module always associates the
# route table it creates with its own subnet
#
# Route table layout: https://docs.aws.amazon.com/network-firewall/latest/developerguide/arch-two-zone-igw.html
# Dedicated gateway route table: https://docs.aws.amazon.com/vpc/latest/userguide/igw-ingress-routing.html
resource "aws_route_table" "igw_ingress" {
  vpc_id = module.vpc.vpc_id

  tags = merge(local.tags, { Name = "${local.name}-igw-ingress" })
}

resource "aws_route_table_association" "igw_ingress" {
  gateway_id     = aws_internet_gateway.this.id
  route_table_id = aws_route_table.igw_ingress.id
}

# Traffic destined for each public subnet is sent to the firewall endpoint in that
# subnet's own availability zone, which is what keeps the flow symmetric
resource "aws_route" "igw_ingress" {
  for_each = local.public_subnets

  route_table_id         = aws_route_table.igw_ingress.id
  destination_cidr_block = each.value
  vpc_endpoint_id        = local.firewall_endpoints["${local.region}${each.key}"].endpoint_id
}

################################################################################
# Network Firewall
################################################################################

module "network_firewall" {
  source  = "terraform-aws-modules/network-firewall/aws"
  version = "~> 1.0"

  # Firewall
  name        = local.name
  description = "Example network firewall"

  # Only for example
  delete_protection                 = false
  firewall_policy_change_protection = false
  subnet_change_protection          = false

  vpc_id = module.vpc.vpc_id
  subnet_mapping = { for k, v in module.firewall_subnet :
    (k) => {
      subnet_id       = v.id
      ip_address_type = "IPV4"
    }
  }

  tags = local.tags
}
