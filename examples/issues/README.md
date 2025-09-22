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
| <a name="module_vpc_issue_108"></a> [vpc\_issue\_108](#module\_vpc\_issue\_108) | ../../ | n/a |
| <a name="module_vpc_issue_44"></a> [vpc\_issue\_44](#module\_vpc\_issue\_44) | ../../ | n/a |
| <a name="module_vpc_issue_46"></a> [vpc\_issue\_46](#module\_vpc\_issue\_46) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->
