# Issues

Configuration in this directory creates set of VPC resources to cover issues reported on GitHub:

- https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/44
- https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/46
- https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/102
- https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/108

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
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.28 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 6.28 |

## Modules

| Name | Source | Version |
| ---- | ------ | ------- |
| <a name="module_asymmetrical_subnets"></a> [asymmetrical\_subnets](#module\_asymmetrical\_subnets) | ../../ | n/a |
| <a name="module_disabled"></a> [disabled](#module\_disabled) | ../../ | n/a |
| <a name="module_no_private_subnets"></a> [no\_private\_subnets](#module\_no\_private\_subnets) | ../../ | n/a |
| <a name="module_overlapping_public_subnets"></a> [overlapping\_public\_subnets](#module\_overlapping\_public\_subnets) | ../../ | n/a |

## Resources

| Name | Type |
| ---- | ---- |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->
