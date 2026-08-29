provider "aws" {
  region = local.region
}

data "aws_availability_zones" "available" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

locals {
  name   = "ex-${basename(path.cwd)}"
  region = "us-west-2"

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 2)

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
# Parent Region
################################################################################

module "region_public_route_table" {
  source = "../../modules/route-table"

  name   = "${local.name}-region-public"
  vpc_id = module.vpc.vpc_id

  routes = {
    igw = { destination_ipv4_cidr_block = "0.0.0.0/0", gateway_id = module.vpc.igw_id }
  }

  tags = local.tags
}

module "region_public_subnet" {
  source   = "../../modules/subnet"
  for_each = { for i, az in local.azs : az => cidrsubnet(local.vpc_cidr, 8, i) }

  name              = "${local.name}-region-public-${each.key}"
  vpc_id            = module.vpc.vpc_id
  availability_zone = each.key
  ipv4_cidr_block   = each.value

  map_public_ip_on_launch = true

  create_route_table = false
  route_table_id     = module.region_public_route_table.id

  create_nat_gateway = each.key == local.azs[0]

  tags = local.tags
}

module "region_private_subnet" {
  source   = "../../modules/subnet"
  for_each = { for i, az in local.azs : az => cidrsubnet(local.vpc_cidr, 8, i + 8) }

  name              = "${local.name}-region-private-${each.key}"
  vpc_id            = module.vpc.vpc_id
  availability_zone = each.key
  ipv4_cidr_block   = each.value

  routes = {
    nat = {
      destination_ipv4_cidr_block = "0.0.0.0/0"
      nat_gateway_id              = module.region_public_subnet[local.azs[0]].nat_gateway_id
    }
  }

  tags = local.tags
}

################################################################################
# Local Zone
#
# Its own gateway and its own address, because outbound traffic leaves from the zone
# and an Elastic IP belongs to a single network border group
################################################################################

module "local_zone_public_subnet" {
  source = "../../modules/subnet"

  name              = "${local.name}-lz-public"
  vpc_id            = module.vpc.vpc_id
  availability_zone = var.local_zone
  ipv4_cidr_block   = cidrsubnet(local.vpc_cidr, 8, 32)

  map_public_ip_on_launch = true

  # the NAT gateway serving the Local Zone lives in the Local Zone
  create_nat_gateway       = true
  eip_network_border_group = var.local_zone_network_border_group

  routes = {
    igw = { destination_ipv4_cidr_block = "0.0.0.0/0", gateway_id = module.vpc.igw_id }
  }

  tags = local.tags
}

module "local_zone_private_subnet" {
  source = "../../modules/subnet"

  name              = "${local.name}-lz-private"
  vpc_id            = module.vpc.vpc_id
  availability_zone = var.local_zone
  ipv4_cidr_block   = cidrsubnet(local.vpc_cidr, 8, 33)

  # pointed at the Local Zone's own gateway, not the Region's
  routes = {
    nat = {
      destination_ipv4_cidr_block = "0.0.0.0/0"
      nat_gateway_id              = module.local_zone_public_subnet.nat_gateway_id
    }
  }

  tags = local.tags
}
