provider "aws" {
  region = local.region
}

data "aws_availability_zones" "available" {}

locals {
  name   = "ex-${basename(path.cwd)}"
  region = "eu-west-1"

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

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

  create_igw = true

  tags = local.tags
}

################################################################################
# Shared: identical routes, so one table with a name of its own
################################################################################

module "shared_route_table" {
  source = "../../modules/route-table"

  name   = "${local.name}-shared"
  vpc_id = module.vpc.vpc_id

  # the generated name is overridden per resource
  route_table_tags = { Name = "${local.name}-public-egress" }

  routes = {
    igw = {
      destination_ipv4_cidr_block = "0.0.0.0/0"
      gateway_id                  = module.vpc.igw_id
    }
  }

  tags = local.tags
}

module "shared_subnet" {
  source   = "../../modules/subnet"
  for_each = { for i, az in local.azs : az => cidrsubnet(local.vpc_cidr, 8, i) }

  name              = "${local.name}-shared-${each.key}"
  vpc_id            = module.vpc.vpc_id
  availability_zone = each.key
  ipv4_cidr_block   = each.value

  map_public_ip_on_launch = true

  # join the shared table rather than making one
  create_route_table = false
  route_table_id     = module.shared_route_table.id

  # each of these hosts a NAT gateway for the tier below
  create_nat_gateway = true

  tags = local.tags
}

################################################################################
# Per subnet: routes differ by zone, so a shared table cannot express them
################################################################################

module "per_az_subnet" {
  source   = "../../modules/subnet"
  for_each = { for i, az in local.azs : az => cidrsubnet(local.vpc_cidr, 8, i + 8) }

  name              = "${local.name}-per-az-${each.key}"
  vpc_id            = module.vpc.vpc_id
  availability_zone = each.key
  ipv4_cidr_block   = each.value

  route_table_tags = { Name = "${local.name}-private-${each.key}" }

  routes = {
    nat = {
      destination_ipv4_cidr_block = "0.0.0.0/0"
      nat_gateway_id              = module.shared_subnet[each.key].nat_gateway_id
    }
  }

  tags = local.tags
}
