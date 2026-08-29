provider "aws" {
  region = local.region
}

data "aws_availability_zones" "available" {}

# the VPC is discovered, not created: nothing here manages it
data "aws_vpc" "existing" {
  tags = {
    Name = var.vpc_tag_name
  }
}

# a VPC can only have one internet gateway, so use the one it already has
data "aws_internet_gateway" "existing" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.existing.id]
  }
}

locals {
  name   = "ex-${basename(path.cwd)}"
  region = "eu-west-1"

  azs = slice(data.aws_availability_zones.available.names, 0, 2)

  # carved from spare space in the existing VPC's CIDR
  public  = { for i, az in local.azs : az => cidrsubnet(data.aws_vpc.existing.cidr_block, 8, i + 200) }
  private = { for i, az in local.azs : az => cidrsubnet(data.aws_vpc.existing.cidr_block, 8, i + 210) }

  tags = {
    Pattern    = local.name
    GithubRepo = "terraform-aws-vpc"
    GithubOrg  = "terraform-aws-modules"
  }
}

################################################################################
# New public subnets, using the VPC's existing gateway
################################################################################

module "public_route_table" {
  source = "../../modules/route-table"

  name   = "${local.name}-public"
  vpc_id = data.aws_vpc.existing.id

  routes = {
    igw = {
      destination_ipv4_cidr_block = "0.0.0.0/0"
      gateway_id                  = data.aws_internet_gateway.existing.id
    }
  }

  tags = local.tags
}

module "public_subnet" {
  source   = "../../modules/subnet"
  for_each = local.public

  name              = "${local.name}-public-${each.key}"
  vpc_id            = data.aws_vpc.existing.id
  availability_zone = each.key
  ipv4_cidr_block   = each.value

  map_public_ip_on_launch = true

  create_route_table = false
  route_table_id     = module.public_route_table.id

  create_nat_gateway = each.key == local.azs[0]

  tags = local.tags
}

################################################################################
# New private subnets, egressing through the new NAT gateway
################################################################################

module "private_route_table" {
  source = "../../modules/route-table"

  name   = "${local.name}-private"
  vpc_id = data.aws_vpc.existing.id

  routes = {
    nat = {
      destination_ipv4_cidr_block = "0.0.0.0/0"
      nat_gateway_id              = module.public_subnet[local.azs[0]].nat_gateway_id
    }
  }

  tags = local.tags
}

module "private_subnet" {
  source   = "../../modules/subnet"
  for_each = local.private

  name              = "${local.name}-private-${each.key}"
  vpc_id            = data.aws_vpc.existing.id
  availability_zone = each.key
  ipv4_cidr_block   = each.value

  create_route_table = false
  route_table_id     = module.private_route_table.id

  tags = local.tags
}
