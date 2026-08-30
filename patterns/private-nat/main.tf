provider "aws" {
  region = local.region
}

data "aws_availability_zones" "available" {}

locals {
  name   = "ex-${basename(path.cwd)}"
  region = "eu-west-1"

  vpc_cidr = "10.0.0.0/16"
  # the range the on-premises network allow-lists
  allowed_cidr = "100.64.1.0/24"
  # what lives on the far side of the VPN
  onprem_cidr = "192.168.0.0/16"

  azs = slice(data.aws_availability_zones.available.names, 0, 2)

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

  # the gateway takes its address from its subnet, so that subnet has to come from
  # the allow-listed range
  secondary_cidr_blocks = [local.allowed_cidr]

  enable_vpn_gateway = true

  tags = local.tags
}

################################################################################
# The private NAT gateway, in a subnet from the allow-listed range
################################################################################

module "nat_subnet" {
  source = "../../modules/subnet"
  # Derived from the VPC's secondary CIDR output rather than the local literal, so
  # Terraform knows these subnets live inside that association. Without the dependency it
  # tries to disassociate the CIDR while the subnets are still in it, and destroy fails
  for_each = { for i, az in local.azs : az => cidrsubnet(module.vpc.vpc_secondary_cidr_blocks[0], 4, i) }

  name              = "${local.name}-nat-${each.key}"
  vpc_id            = module.vpc.vpc_id
  availability_zone = each.key
  ipv4_cidr_block   = each.value

  create_nat_gateway            = true
  nat_gateway_connectivity_type = "private"
  # a private NAT gateway takes no allocation, so no address is created for it
  create_eip = false

  # once translated, traffic carries on to the on-premises network
  routes = {
    onprem = {
      destination_ipv4_cidr_block = local.onprem_cidr
      gateway_id                  = module.vpc.vgw_id
    }
  }

  tags = local.tags
}

################################################################################
# Workload subnets, translating before they route on-premises
#
# Each zone translates at its own gateway, so the routes differ per subnet and each
# subnet keeps a route table of its own
################################################################################

module "workload" {
  source = "../../modules/subnets"

  name   = "${local.name}-workload"
  vpc_id = module.vpc.vpc_id

  subnets = { for i, az in local.azs : az => {
    availability_zone = az
    ipv4_cidr_block   = cidrsubnet(local.vpc_cidr, 8, i)

    routes = {
      onprem = {
        destination_ipv4_cidr_block = local.onprem_cidr
        nat_gateway_id              = module.nat_subnet[az].nat_gateway_id
      }
    }
  } }

  tags = local.tags
}
