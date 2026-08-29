provider "aws" {
  region = local.region
}

data "aws_availability_zones" "available" {}

locals {
  name   = "ex-${basename(path.cwd)}"
  region = "eu-west-1"

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  # the zone that hosts the one NAT gateway
  nat_zone = local.azs[0]

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
# Public subnets, with a NAT gateway in one zone only
################################################################################

module "public_route_table" {
  source = "../../modules/route-table"

  name   = "${local.name}-public"
  vpc_id = module.vpc.vpc_id

  routes = {
    igw = {
      destination_ipv4_cidr_block = "0.0.0.0/0"
      gateway_id                  = module.vpc.igw_id
    }
  }

  tags = local.tags
}

module "public_subnet" {
  source   = "../../modules/subnet"
  for_each = { for i, az in local.azs : az => cidrsubnet(local.vpc_cidr, 8, i) }

  name              = "${local.name}-public-${each.key}"
  vpc_id            = module.vpc.vpc_id
  availability_zone = each.key
  ipv4_cidr_block   = each.value

  map_public_ip_on_launch = true

  create_route_table = false
  route_table_id     = module.public_route_table.id

  # Placement is simply which subnet asks for one
  create_nat_gateway = each.key == local.nat_zone

  tags = local.tags
}

################################################################################
# Private subnets, all sharing one route table to the one gateway
################################################################################

module "private_route_table" {
  source = "../../modules/route-table"

  name   = "${local.name}-private"
  vpc_id = module.vpc.vpc_id

  routes = {
    nat = {
      destination_ipv4_cidr_block = "0.0.0.0/0"
      nat_gateway_id              = module.public_subnet[local.nat_zone].nat_gateway_id
    }
  }

  tags = local.tags
}

module "private_subnet" {
  source   = "../../modules/subnet"
  for_each = { for i, az in local.azs : az => cidrsubnet(local.vpc_cidr, 8, i + 8) }

  name              = "${local.name}-private-${each.key}"
  vpc_id            = module.vpc.vpc_id
  availability_zone = each.key
  ipv4_cidr_block   = each.value

  create_route_table = false
  route_table_id     = module.private_route_table.id

  tags = local.tags
}
