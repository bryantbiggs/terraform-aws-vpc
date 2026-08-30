# Shared Route Tables

One route table serving many subnets, with a name you chose, and a second tier that gets
a table per subnet. Both in the same configuration, so the difference is visible.

## The rule

A route table can be shared when every subnet using it needs identical routes, and must
be per subnet when the routes differ. Nothing else decides it.

| Situation | Table |
| --------- | ----- |
| Public subnets, all routing to one internet gateway | shared |
| Private subnets, all routing to one NAT gateway | shared |
| Private subnets, each routing to the NAT in its own zone | one per subnet |
| Public subnets, each routing to a firewall endpoint in its own zone | one per subnet |

## Architecture

```
   VPC 10.0.0.0/16
   ┌──────────────────────────────────────────────────────────────────┐
   │  SHARED   one table, three subnets, identical routes             │
   │    0.0.0.0/0 → IGW                                               │
   │      ├── shared-a   ├── shared-b   ├── shared-c                  │
   │                                                                  │
   │  PER SUBNET   three tables, three subnets, divergent routes      │
   │    per-az-a: 0.0.0.0/0 → NAT a                                   │
   │    per-az-b: 0.0.0.0/0 → NAT b                                   │
   │    per-az-c: 0.0.0.0/0 → NAT c                                   │
   └──────────────────────────────────────────────────────────────────┘
```

## How it is expressed

Nothing sets a flag. The `subnets` sub-module reads where the routes are written. Routes
declared once on the group mean every subnet in it routes identically, so it builds one
table and associates all of them with it. Routes declared inside a subnet entry mean they
differ, so that subnet takes a table of its own.

The two tiers in this pattern are the same module block with the same arguments. Only the
position of `routes` changes, and the number of route tables follows from it.

Naming splits the same way. `route_table_tags = { Name = ... }` renames the one table a
group shares, so it is named independently of its subnets. Tables created per subnet take
the name of the subnet that owns them.

## Requests this answers

- [#1171](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/1171) Create multiple route tables for all route table types
- [#1119](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/1119) Custom names for private and public route tables
- [#1083](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/1083) Route table association issues
- [#1283](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/1283) Associating the public route table to a database subnet

## References

- [Subnet route tables](https://docs.aws.amazon.com/vpc/latest/userguide/subnet-route-tables.html)

## Usage

```bash
$ terraform init && terraform apply
```
