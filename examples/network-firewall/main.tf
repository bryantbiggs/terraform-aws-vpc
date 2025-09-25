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
  vpc_id = module.vpc.id

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

# output "firewall_status" {
#   # value = { for s in module.network_firewall.status[*].sync_states : s.attachment[0].subnet_id => s.attachment[0].endpoint_id }
#   # value = flatten(module.network_firewall.status[*].sync_states)
#   value = {
#     for s in flatten(module.network_firewall.status[*].sync_states) : s.availability_zone => {
#       subnet_id   = s.attachment[0].subnet_id
#       endpoint_id = s.attachment[0].endpoint_id
#     }
#   }
# }

module "firewall_subnet" {
  source = "../../modules/subnet"

  for_each = { for k, v in local.firewall_subnets :
    "${local.region}${k}" => {
      ipv4_cidr_block = v
    }
  }

  name   = "${local.name}-firewall-${each.key}"
  vpc_id = module.vpc.id

  availability_zone = each.key
  ipv4_cidr_block   = each.value.ipv4_cidr_block

  routes = {
    igw = {
      destination_ipv4_cidr_block = "0.0.0.0/0"
      gateway_id                  = module.vpc.internet_gateway_id
    }
  }

  tags = local.tags
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

  vpc_id = module.vpc.id
  subnet_mapping = { for k, v in module.firewall_subnet :
    (k) => {
      subnet_id       = v.id
      ip_address_type = "IPV4"
    }
  }

  tags = local.tags
}
