# Simple VPC

Configuration in this directory creates set of VPC resources which may be sufficient for development environment.

There is a public and private subnet created per availability zone in addition to single NAT Gateway shared between all 3 availability zones.

This configuration uses Availability Zone IDs and Availability Zone names for demonstration purposes. Normally, you need to specify only names or IDs.

[Read more about AWS regions, availability zones and local zones](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html#concepts-regions-availability-zones).

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which can cost money (AWS Elastic IP, for example). Run `terraform destroy` when you don't need these resources.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 6.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc"></a> [vpc](#module\_vpc) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_azs"></a> [azs](#output\_azs) | A list of availability zones specified as argument to this module |
| <a name="output_customer_gateways"></a> [customer\_gateways](#output\_customer\_gateways) | Map of Customer Gateway's created and their attributes |
| <a name="output_database_network_acl_arn"></a> [database\_network\_acl\_arn](#output\_database\_network\_acl\_arn) | ARN of the database network ACL |
| <a name="output_database_network_acl_id"></a> [database\_network\_acl\_id](#output\_database\_network\_acl\_id) | ID of the database network ACL |
| <a name="output_database_route_table_ids"></a> [database\_route\_table\_ids](#output\_database\_route\_table\_ids) | List of IDs of database route tables |
| <a name="output_database_subnet_arns"></a> [database\_subnet\_arns](#output\_database\_subnet\_arns) | List of ARNs of database subnets |
| <a name="output_database_subnet_cidr_blocks"></a> [database\_subnet\_cidr\_blocks](#output\_database\_subnet\_cidr\_blocks) | List of cidr\_blocks of database subnets |
| <a name="output_database_subnet_group_id"></a> [database\_subnet\_group\_id](#output\_database\_subnet\_group\_id) | ID of database subnet group |
| <a name="output_database_subnet_group_name"></a> [database\_subnet\_group\_name](#output\_database\_subnet\_group\_name) | Name of database subnet group |
| <a name="output_database_subnet_ids"></a> [database\_subnet\_ids](#output\_database\_subnet\_ids) | List of IDs of database subnets |
| <a name="output_database_subnet_ipv6_cidr_blocks"></a> [database\_subnet\_ipv6\_cidr\_blocks](#output\_database\_subnet\_ipv6\_cidr\_blocks) | List of IPv6 cidr\_blocks of database subnets in an IPv6 enabled VPC |
| <a name="output_database_subnets"></a> [database\_subnets](#output\_database\_subnets) | A list of all subnets created and their attributes |
| <a name="output_default_network_acl_id"></a> [default\_network\_acl\_id](#output\_default\_network\_acl\_id) | The ID of the default network ACL |
| <a name="output_default_route_table_id"></a> [default\_route\_table\_id](#output\_default\_route\_table\_id) | The ID of the default route table |
| <a name="output_default_security_group_id"></a> [default\_security\_group\_id](#output\_default\_security\_group\_id) | The ID of the security group created by default on VPC creation |
| <a name="output_dhcp_options_id"></a> [dhcp\_options\_id](#output\_dhcp\_options\_id) | The ID of the DHCP options |
| <a name="output_egress_only_internet_gateway_id"></a> [egress\_only\_internet\_gateway\_id](#output\_egress\_only\_internet\_gateway\_id) | The ID of the egress only Internet Gateway |
| <a name="output_elasticache_network_acl_arn"></a> [elasticache\_network\_acl\_arn](#output\_elasticache\_network\_acl\_arn) | ARN of the elasticache network ACL |
| <a name="output_elasticache_network_acl_id"></a> [elasticache\_network\_acl\_id](#output\_elasticache\_network\_acl\_id) | ID of the elasticache network ACL |
| <a name="output_elasticache_route_table_ids"></a> [elasticache\_route\_table\_ids](#output\_elasticache\_route\_table\_ids) | List of IDs of elasticache route tables |
| <a name="output_elasticache_subnet_arns"></a> [elasticache\_subnet\_arns](#output\_elasticache\_subnet\_arns) | List of ARNs of elasticache subnets |
| <a name="output_elasticache_subnet_cidr_blocks"></a> [elasticache\_subnet\_cidr\_blocks](#output\_elasticache\_subnet\_cidr\_blocks) | List of cidr\_blocks of elasticache subnets |
| <a name="output_elasticache_subnet_group_id"></a> [elasticache\_subnet\_group\_id](#output\_elasticache\_subnet\_group\_id) | ID of elasticache subnet group |
| <a name="output_elasticache_subnet_group_name"></a> [elasticache\_subnet\_group\_name](#output\_elasticache\_subnet\_group\_name) | Name of elasticache subnet group |
| <a name="output_elasticache_subnet_ids"></a> [elasticache\_subnet\_ids](#output\_elasticache\_subnet\_ids) | List of IDs of elasticache subnets |
| <a name="output_elasticache_subnet_ipv6_cidr_blocks"></a> [elasticache\_subnet\_ipv6\_cidr\_blocks](#output\_elasticache\_subnet\_ipv6\_cidr\_blocks) | List of IPv6 cidr\_blocks of elasticache subnets in an IPv6 enabled VPC |
| <a name="output_elasticache_subnets"></a> [elasticache\_subnets](#output\_elasticache\_subnets) | A list of all subnets created and their attributes |
| <a name="output_internet_gateway_arn"></a> [internet\_gateway\_arn](#output\_internet\_gateway\_arn) | The ARN of the Internet Gateway |
| <a name="output_internet_gateway_id"></a> [internet\_gateway\_id](#output\_internet\_gateway\_id) | The ID of the Internet Gateway |
| <a name="output_intra_network_acl_arn"></a> [intra\_network\_acl\_arn](#output\_intra\_network\_acl\_arn) | ARN of the intra network ACL |
| <a name="output_intra_network_acl_id"></a> [intra\_network\_acl\_id](#output\_intra\_network\_acl\_id) | ID of the intra network ACL |
| <a name="output_intra_route_table_ids"></a> [intra\_route\_table\_ids](#output\_intra\_route\_table\_ids) | List of IDs of intra route tables |
| <a name="output_intra_subnet_arns"></a> [intra\_subnet\_arns](#output\_intra\_subnet\_arns) | List of ARNs of intra subnets |
| <a name="output_intra_subnet_cidr_blocks"></a> [intra\_subnet\_cidr\_blocks](#output\_intra\_subnet\_cidr\_blocks) | List of cidr\_blocks of intra subnets |
| <a name="output_intra_subnet_ids"></a> [intra\_subnet\_ids](#output\_intra\_subnet\_ids) | List of IDs of intra subnets |
| <a name="output_intra_subnet_ipv6_cidr_blocks"></a> [intra\_subnet\_ipv6\_cidr\_blocks](#output\_intra\_subnet\_ipv6\_cidr\_blocks) | List of IPv6 cidr\_blocks of intra subnets in an IPv6 enabled VPC |
| <a name="output_intra_subnets"></a> [intra\_subnets](#output\_intra\_subnets) | A list of all subnets created and their attributes |
| <a name="output_name"></a> [name](#output\_name) | The name of the VPC specified as argument to this module |
| <a name="output_nat_gateway_ids"></a> [nat\_gateway\_ids](#output\_nat\_gateway\_ids) | List of NAT Gateway IDs |
| <a name="output_nat_gateway_interface_ids"></a> [nat\_gateway\_interface\_ids](#output\_nat\_gateway\_interface\_ids) | List of Network Interface IDs assigned to NAT Gateways |
| <a name="output_nat_gateway_public_ips"></a> [nat\_gateway\_public\_ips](#output\_nat\_gateway\_public\_ips) | List of public Elastic IPs used by the AWS NAT Gateways created |
| <a name="output_outpost_network_acl_arn"></a> [outpost\_network\_acl\_arn](#output\_outpost\_network\_acl\_arn) | ARN of the outpost network ACL |
| <a name="output_outpost_network_acl_id"></a> [outpost\_network\_acl\_id](#output\_outpost\_network\_acl\_id) | ID of the outpost network ACL |
| <a name="output_outpost_subnet_arns"></a> [outpost\_subnet\_arns](#output\_outpost\_subnet\_arns) | List of ARNs of outpost subnets |
| <a name="output_outpost_subnet_cidr_blocks"></a> [outpost\_subnet\_cidr\_blocks](#output\_outpost\_subnet\_cidr\_blocks) | List of cidr\_blocks of outpost subnets |
| <a name="output_outpost_subnet_ids"></a> [outpost\_subnet\_ids](#output\_outpost\_subnet\_ids) | List of IDs of outpost subnets |
| <a name="output_outpost_subnet_ipv6_cidr_blocks"></a> [outpost\_subnet\_ipv6\_cidr\_blocks](#output\_outpost\_subnet\_ipv6\_cidr\_blocks) | List of IPv6 cidr\_blocks of outpost subnets in an IPv6 enabled VPC |
| <a name="output_outpost_subnets"></a> [outpost\_subnets](#output\_outpost\_subnets) | A list of all subnets created and their attributes |
| <a name="output_private_network_acl_arn"></a> [private\_network\_acl\_arn](#output\_private\_network\_acl\_arn) | ARN of the private network ACL |
| <a name="output_private_network_acl_id"></a> [private\_network\_acl\_id](#output\_private\_network\_acl\_id) | ID of the private network ACL |
| <a name="output_private_route_table_ids"></a> [private\_route\_table\_ids](#output\_private\_route\_table\_ids) | List of IDs of private route tables |
| <a name="output_private_subnet_arns"></a> [private\_subnet\_arns](#output\_private\_subnet\_arns) | List of ARNs of private subnets |
| <a name="output_private_subnet_cidr_blocks"></a> [private\_subnet\_cidr\_blocks](#output\_private\_subnet\_cidr\_blocks) | List of cidr\_blocks of private subnets |
| <a name="output_private_subnet_ids"></a> [private\_subnet\_ids](#output\_private\_subnet\_ids) | List of IDs of private subnets |
| <a name="output_private_subnet_ipv6_cidr_blocks"></a> [private\_subnet\_ipv6\_cidr\_blocks](#output\_private\_subnet\_ipv6\_cidr\_blocks) | List of IPv6 cidr\_blocks of private subnets in an IPv6 enabled VPC |
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | A list of all subnets created and their attributes |
| <a name="output_public_network_acl_arn"></a> [public\_network\_acl\_arn](#output\_public\_network\_acl\_arn) | ARN of the public network ACL |
| <a name="output_public_network_acl_id"></a> [public\_network\_acl\_id](#output\_public\_network\_acl\_id) | ID of the public network ACL |
| <a name="output_public_route_table_ids"></a> [public\_route\_table\_ids](#output\_public\_route\_table\_ids) | List of IDs of public route tables |
| <a name="output_public_subnet_arns"></a> [public\_subnet\_arns](#output\_public\_subnet\_arns) | List of ARNs of public subnets |
| <a name="output_public_subnet_cidr_blocks"></a> [public\_subnet\_cidr\_blocks](#output\_public\_subnet\_cidr\_blocks) | List of cidr\_blocks of public subnets |
| <a name="output_public_subnet_ids"></a> [public\_subnet\_ids](#output\_public\_subnet\_ids) | List of IDs of public subnets |
| <a name="output_public_subnet_ipv6_cidr_blocks"></a> [public\_subnet\_ipv6\_cidr\_blocks](#output\_public\_subnet\_ipv6\_cidr\_blocks) | List of IPv6 cidr\_blocks of public subnets in an IPv6 enabled VPC |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | A list of all subnets created and their attributes |
| <a name="output_redshift_network_acl_arn"></a> [redshift\_network\_acl\_arn](#output\_redshift\_network\_acl\_arn) | ARN of the redshift network ACL |
| <a name="output_redshift_network_acl_id"></a> [redshift\_network\_acl\_id](#output\_redshift\_network\_acl\_id) | ID of the redshift network ACL |
| <a name="output_redshift_route_table_ids"></a> [redshift\_route\_table\_ids](#output\_redshift\_route\_table\_ids) | List of IDs of redshift route tables |
| <a name="output_redshift_subnet_arns"></a> [redshift\_subnet\_arns](#output\_redshift\_subnet\_arns) | List of ARNs of redshift subnets |
| <a name="output_redshift_subnet_cidr_blocks"></a> [redshift\_subnet\_cidr\_blocks](#output\_redshift\_subnet\_cidr\_blocks) | List of cidr\_blocks of redshift subnets |
| <a name="output_redshift_subnet_group_id"></a> [redshift\_subnet\_group\_id](#output\_redshift\_subnet\_group\_id) | ID of redshift subnet group |
| <a name="output_redshift_subnet_ids"></a> [redshift\_subnet\_ids](#output\_redshift\_subnet\_ids) | List of IDs of redshift subnets |
| <a name="output_redshift_subnet_ipv6_cidr_blocks"></a> [redshift\_subnet\_ipv6\_cidr\_blocks](#output\_redshift\_subnet\_ipv6\_cidr\_blocks) | List of IPv6 cidr\_blocks of redshift subnets in an IPv6 enabled VPC |
| <a name="output_redshift_subnets"></a> [redshift\_subnets](#output\_redshift\_subnets) | A list of all subnets created and their attributes |
| <a name="output_vpc_arn"></a> [vpc\_arn](#output\_vpc\_arn) | The ARN of the VPC |
| <a name="output_vpc_cidr_block"></a> [vpc\_cidr\_block](#output\_vpc\_cidr\_block) | The CIDR block of the VPC |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |
| <a name="output_vpc_ipv6_cidr_block"></a> [vpc\_ipv6\_cidr\_block](#output\_vpc\_ipv6\_cidr\_block) | The IPv6 CIDR block |
| <a name="output_vpc_main_route_table_id"></a> [vpc\_main\_route\_table\_id](#output\_vpc\_main\_route\_table\_id) | The ID of the main route table associated with this VPC |
| <a name="output_vpc_owner_id"></a> [vpc\_owner\_id](#output\_vpc\_owner\_id) | The ID of the AWS account that owns the VPC |
| <a name="output_vpc_secondary_cidr_blocks"></a> [vpc\_secondary\_cidr\_blocks](#output\_vpc\_secondary\_cidr\_blocks) | List of secondary CIDR blocks of the VPC |
| <a name="output_vpn_gateway_arn"></a> [vpn\_gateway\_arn](#output\_vpn\_gateway\_arn) | The ARN of the VPN Gateway |
| <a name="output_vpn_gateway_id"></a> [vpn\_gateway\_id](#output\_vpn\_gateway\_id) | The ID of the VPN Gateway |
<!-- END_TF_DOCS -->
