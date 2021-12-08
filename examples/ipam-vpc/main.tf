provider "aws" {
  region = "eu-west-1"
}

locals {
  name        = "ipam-vpc-example"
  ipv6_deploy = var.ipv6_pool_cidr != null && var.ipv6_pool_cidr_authorization_message != null && var.ipv6_pool_cidr_authorization_signature != null ? true : false
}

# IPAM Setup
data "aws_region" "current" {}

resource "aws_vpc_ipam" "example" {
  operating_regions {
    region_name = data.aws_region.current.name
  }
}

# IPv4 Setup

resource "aws_vpc_ipam_pool" "ipv4_example" {
  address_family                    = "ipv4"
  ipam_scope_id                     = aws_vpc_ipam.example.private_default_scope_id
  locale                            = data.aws_region.current.name
  allocation_default_netmask_length = 28
}

resource "aws_vpc_ipam_pool_cidr" "ipv4_example" {
  ipam_pool_id = aws_vpc_ipam_pool.ipv4_example.id
  cidr         = "172.2.0.0/16"
}

# IPv6 Setup

resource "aws_vpc_ipam_pool" "ipv6_test_public" {
  count = local.ipv6_deploy ? 1 : 0

  address_family                    = "ipv6"
  ipam_scope_id                     = aws_vpc_ipam.example.public_default_scope_id
  locale                            = data.aws_region.current.name
  description                       = "public ipv6"
  publicly_advertisable             = false
  aws_service                       = "ec2"
  allocation_default_netmask_length = 56

}

resource "aws_vpc_ipam_pool_cidr" "ipv6_test_public" {
  count = local.ipv6_deploy ? 1 : 0

  ipam_pool_id = aws_vpc_ipam_pool.ipv6_test_public[0].id
  cidr         = var.ipv6_pool_cidr
  cidr_authorization_context {
    message   = var.ipv6_pool_cidr_authorization_message
    signature = var.ipv6_pool_cidr_authorization_signature
  }
}


# Usage Patterns

# IPv4 VPC Examples

module "no_ipam_vpc_example" {
  source = "../.."
  name   = "no-ipam-${local.name}"
  cidr   = "172.2.0.32/28"
}

module "ipv4_ipam_explicit_cidr_vpc" {
  source            = "../.."
  name              = "ipv4-explicit-cidr-${local.name}"
  ipv4_ipam_pool_id = aws_vpc_ipam_pool.ipv4_example.id
  cidr              = "172.2.0.32/28"
  depends_on = [
    aws_vpc_ipam_pool_cidr.ipv4_example
  ]
}

module "ipv4_ipam_explicit_netmask_vpc" {
  source              = "../.."
  name                = "ipv4-explicit-netmask-${local.name}"
  ipv4_ipam_pool_id   = aws_vpc_ipam_pool.ipv4_example.id
  ipv4_netmask_length = 28
  depends_on = [
    aws_vpc_ipam_pool_cidr.ipv4_example
  ]
}

module "ipv4_ipam_default_netmask_vpc" {
  source            = "../.."
  name              = "ipv4-default-netmask-${local.name}"
  ipv4_ipam_pool_id = aws_vpc_ipam_pool.ipv4_example.id
  depends_on = [
    aws_vpc_ipam_pool_cidr.ipv4_example
  ]
}

# IPv6 VPC Examples

module "ipv6_ipam_explicit_cidr_vpc" {
  count = local.ipv6_deploy && var.ipv6_ipam_explicit_cidr != null ? 1 : 0

  source            = "../.."
  name              = "ipv6-explicit-cidr-${local.name}"
  cidr              = "172.2.0.32/28"
  ipv6_ipam_pool_id = aws_vpc_ipam_pool.ipv6_test_public[0].id
  ipv6_cidr         = var.ipv6_ipam_explicit_cidr
  depends_on = [
    aws_vpc_ipam_pool_cidr.ipv6_test_public
  ]
}

module "ipv6_ipam_explicit_netmask_vpc" {
  count = local.ipv6_deploy ? 1 : 0

  source              = "../.."
  name                = "ipv6-explicit-netmask-${local.name}"
  cidr                = "172.2.0.32/28"
  ipv6_ipam_pool_id   = aws_vpc_ipam_pool.ipv6_test_public[0].id
  ipv6_netmask_length = 56
  depends_on = [
    aws_vpc_ipam_pool_cidr.ipv6_test_public
  ]
}

module "ipv6_ipam_default_netmask_vpc" {
  count = local.ipv6_deploy ? 1 : 0

  source            = "../.."
  name              = "ipv6-default-netmask-${local.name}"
  cidr              = "172.2.0.32/28"
  ipv6_ipam_pool_id = aws_vpc_ipam_pool.ipv6_test_public[0].id
  depends_on = [
    aws_vpc_ipam_pool_cidr.ipv6_test_public
  ]
}
