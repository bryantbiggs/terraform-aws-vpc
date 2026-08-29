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

################################################################################
# VPC
################################################################################

module "vpc" {
  source = "../../"

  name = local.name
  cidr = local.vpc_cidr

  azs = local.azs

  tags = local.tags
}


################################################################################
# Private Subnets
#
# One route table for every zone, because every subnet routes to the same gateway ID
################################################################################

module "private_route_table" {
  source = "../../modules/route-table"

  name   = "${local.name}-private"
  vpc_id = module.vpc.vpc_id

  routes = {
    nat = {
      destination_ipv4_cidr_block = "0.0.0.0/0"
      nat_gateway_id              = module.vpc.regional_nat_gateway_id
    }
  }

  tags = local.tags
}

module "private_subnet" {
  source   = "../../modules/subnet"
  for_each = { for i, az in local.azs : az => cidrsubnet(local.vpc_cidr, 8, i) }

  name              = "${local.name}-private-${each.key}"
  vpc_id            = module.vpc.vpc_id
  availability_zone = each.key
  ipv4_cidr_block   = each.value

  create_route_table = false
  route_table_id     = module.private_route_table.id

  tags = local.tags
}
