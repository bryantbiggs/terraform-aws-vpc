provider "aws" {
  region = local.region
}

data "aws_availability_zones" "available" {}

locals {
  name   = "ex-${basename(path.cwd)}"
  region = "eu-west-1"

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 2)

  # the well known prefix DNS64 synthesises into, routed at a NAT gateway for NAT64
  nat64_prefix = "64:ff9b::/96"

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

  enable_ipv6 = true
  create_igw  = true

  # the IPv6 equivalent of a NAT gateway: outbound only, stateful, no translation
  create_egress_only_igw = true

  tags = local.tags
}

################################################################################
# Public: dual stack, both defaults at the internet gateway
################################################################################

module "public_route_table" {
  source = "../../modules/route-table"

  name   = "${local.name}-public"
  vpc_id = module.vpc.vpc_id

  routes = {
    ipv4 = { destination_ipv4_cidr_block = "0.0.0.0/0", gateway_id = module.vpc.igw_id }
    ipv6 = { destination_ipv6_cidr_block = "::/0", gateway_id = module.vpc.igw_id }
  }

  tags = local.tags
}

module "public_subnet" {
  source   = "../../modules/subnet"
  for_each = { for i, az in local.azs : az => i }

  name              = "${local.name}-public-${each.key}"
  vpc_id            = module.vpc.vpc_id
  availability_zone = each.key
  ipv4_cidr_block   = cidrsubnet(local.vpc_cidr, 8, each.value)
  ipv6_cidr_block   = cidrsubnet(module.vpc.vpc_ipv6_cidr_block, 8, each.value)

  map_public_ip_on_launch         = true
  assign_ipv6_address_on_creation = true

  create_route_table = false
  route_table_id     = module.public_route_table.id

  create_nat_gateway = each.value == 0

  tags = local.tags
}

################################################################################
# Private: dual stack, IPv4 through the NAT gateway, IPv6 outbound only
################################################################################

module "private_route_table" {
  source = "../../modules/route-table"

  name   = "${local.name}-private"
  vpc_id = module.vpc.vpc_id

  routes = {
    ipv4 = {
      destination_ipv4_cidr_block = "0.0.0.0/0"
      nat_gateway_id              = module.public_subnet[local.azs[0]].nat_gateway_id
    }
    # no translation, so no NAT gateway on this path
    ipv6 = {
      destination_ipv6_cidr_block = "::/0"
      egress_only_gateway_id      = module.vpc.egress_only_internet_gateway_id
    }
  }

  tags = local.tags
}

module "private_subnet" {
  source   = "../../modules/subnet"
  for_each = { for i, az in local.azs : az => i }

  name              = "${local.name}-private-${each.key}"
  vpc_id            = module.vpc.vpc_id
  availability_zone = each.key
  ipv4_cidr_block   = cidrsubnet(local.vpc_cidr, 8, each.value + 8)
  ipv6_cidr_block   = cidrsubnet(module.vpc.vpc_ipv6_cidr_block, 8, each.value + 8)

  assign_ipv6_address_on_creation = true

  create_route_table = false
  route_table_id     = module.private_route_table.id

  tags = local.tags
}

################################################################################
# IPv6 only: no IPv4 address at all, reaching IPv4 hosts through DNS64 and NAT64
################################################################################

module "ipv6_only_route_table" {
  source = "../../modules/route-table"

  name   = "${local.name}-ipv6-only"
  vpc_id = module.vpc.vpc_id

  routes = {
    ipv6 = {
      destination_ipv6_cidr_block = "::/0"
      egress_only_gateway_id      = module.vpc.egress_only_internet_gateway_id
    }
    # without this, DNS64 resolves names that then never connect
    nat64 = {
      destination_ipv6_cidr_block = local.nat64_prefix
      nat_gateway_id              = module.public_subnet[local.azs[0]].nat_gateway_id
    }
  }

  tags = local.tags
}

module "ipv6_only_subnet" {
  source   = "../../modules/subnet"
  for_each = { for i, az in local.azs : az => i }

  name              = "${local.name}-ipv6-only-${each.key}"
  vpc_id            = module.vpc.vpc_id
  availability_zone = each.key
  ipv6_cidr_block   = cidrsubnet(module.vpc.vpc_ipv6_cidr_block, 8, each.value + 16)

  ipv6_native                     = true
  assign_ipv6_address_on_creation = true

  # synthesise IPv6 answers for IPv4 only destinations
  enable_dns64 = true

  create_route_table = false
  route_table_id     = module.ipv6_only_route_table.id

  tags = local.tags
}
