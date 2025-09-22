# Upgrade from v6.x to v7.x

If you have any questions regarding this upgrade process, please consult the [`examples`](https://github.com/terraform-aws-modules/terraform-aws-vpc/tree/master/examples) directory:
If you find a bug, please open an issue with supporting configuration to reproduce.

## List of backwards incompatible changes

- Terraform `v1.5.7` is now minimum supported version

## Additional changes

### Added

-

### Modified

- Variable definitions now contain detailed `object` types in place of the previously used any type.

### Variable and output changes

1. Removed variables:

    -

2. Renamed variables:

    -

3. Added variables:

    -

4. Removed outputs:

    - `vpc_block_public_access_exclusions`
    - Route table association IDs (e.g., `public_route_table_association_ids`) have been removed
    - `vpc_flow_log_destination_type`
    - `default_vpc_*` outputs have been consolidated into a single `default_vpc` output containing all attributes of the default VPC. Given the low use of these outputs, this simplifies the number of outputs exposed to users while still providing the same level of access to information.
    - `cgw_ids` and `cgw_arns` have been removed. Use the `customer_gateway` output instead, which provides the full resource attributes.
    - `nat_ids` - mis-leading given that its a list of EIP allocation IDs
    - `instance_tenancy` given this is controlled by an input variable
    - `enable_dns_support` given this is controlled by an input variable
    - `enable_dns_hostnames` given this is controlled by an input variable
    - `*_route_table_association_ids`

5. Renamed outputs:

    - Outputs have been stripped of `vpc_` prefix for conciseness. For example, `vpc_id` is now `id`.
    - Subnet outputs of `*_subnets` have been renamed to `*_subnet_ids` for clarity.
    - Subnet outputs of `*_subnet_objects` have been renamed to `*_subnets` for clarity.
    - Subnet outputs of `*_subnets_cidr_blocks` and `*_subnets_ipv6_cidr_blocks` have been renamed to `*_subnet_cidr_blocks` and `*_subnet_ipv6_cidr_blocks` respectively for clarity.
    - `vgw_id` -> `vpn_gateway_id`
    - `vgw_arn` -> `vpn_gateway_arn`
    - `this_customer_gateway` -> `customer_gateways`
    - `nat_public_ips` -> `nat_gateway_public_ips`
    - `natgw_ids` -> `nat_gateway_ids`
    - `natgw_interface_ids` -> `nat_gateway_interface_ids`
    - `igw_id` -> `internet_gateway_id`
    - `igw_arn` -> `internet_gateway_arn`
    - `elasticache_subnet_group` -> `elasticache_subnet_group_id` for clarity
    - `redshift_subnet_group` -> `redshift_subnet_group_id` for clarity
    - `database_subnet_group` -> `database_subnet_group_id` for clarity
    - `aws_route` outputs have been removed entirely given that their outputs are not readily used as inputs to other resources

6. Added outputs:

    -

## Upgrade Migrations

### State Changes
