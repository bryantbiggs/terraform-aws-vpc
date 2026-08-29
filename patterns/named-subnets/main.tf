provider "aws" {
  region = local.region
}

data "aws_availability_zones" "available" {}

locals {
  name   = "ex-${basename(path.cwd)}"
  region = "eu-west-1"

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  # Named by what they are for, sized by what they hold, placed where they are needed.
  # Note the asymmetry: pods and nodes in two zones, cache in one, transit in one
  subnets = {
    eks-pods-a = { availability_zone = local.azs[0], ipv4_cidr_block = cidrsubnet(local.vpc_cidr, 2, 2) }
    eks-pods-b = { availability_zone = local.azs[1], ipv4_cidr_block = cidrsubnet(local.vpc_cidr, 2, 3) }

    eks-nodes-a = { availability_zone = local.azs[0], ipv4_cidr_block = cidrsubnet(local.vpc_cidr, 8, 0) }
    eks-nodes-b = { availability_zone = local.azs[1], ipv4_cidr_block = cidrsubnet(local.vpc_cidr, 8, 1) }

    cache-public = { availability_zone = local.azs[2], ipv4_cidr_block = cidrsubnet(local.vpc_cidr, 8, 2) }

    transit = { availability_zone = local.azs[0], ipv4_cidr_block = cidrsubnet(local.vpc_cidr, 12, 48) }
  }

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

module "route_table" {
  source = "../../modules/route-table"

  name   = local.name
  vpc_id = module.vpc.vpc_id

  routes = {
    igw = { destination_ipv4_cidr_block = "0.0.0.0/0", gateway_id = module.vpc.igw_id }
  }

  tags = local.tags
}

module "subnet" {
  source   = "../../modules/subnet"
  for_each = local.subnets

  # the key is the name, and it is also the Terraform address
  name              = "${local.name}-${each.key}"
  vpc_id            = module.vpc.vpc_id
  availability_zone = each.value.availability_zone
  ipv4_cidr_block   = each.value.ipv4_cidr_block

  create_route_table = false
  route_table_id     = module.route_table.id

  # tags that mean something for the workload, per subnet
  subnet_tags = startswith(each.key, "eks-") ? { "kubernetes.io/role/internal-elb" = "1" } : {}

  tags = local.tags
}
