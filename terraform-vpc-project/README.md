# AWS VPC with Public and Private Subnets (Terraform)

This project creates:
- One VPC
- One public subnet and one private subnet
- One Internet Gateway
- Public and private route tables
- Route table associations
- One Elastic IP
- One NAT Gateway in the public subnet

## CIDR layout

| Resource | CIDR |
|---|---|
| VPC | `10.0.0.0/16` |
| Public subnet | `10.0.1.0/24` |
| Private subnet | `10.0.2.0/24` |
| Public default route | `0.0.0.0/0` via Internet Gateway |
| Private default route | `0.0.0.0/0` via NAT Gateway |

The VPC CIDR uses private IPv4 address space. Do not use `110.0.0.0/16` for a new VPC because it is public address space.

## Prerequisites

1. Terraform installed.
2. AWS CLI installed and configured, or another supported AWS credentials method.
3. AWS permissions to create VPC, subnet, route table, Internet Gateway, Elastic IP and NAT Gateway resources.

For AWS CLI credentials, run `aws configure`. Never put access keys in Terraform files or commit them to GitHub.

## Deploy

```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

Review the plan and type `yes` when Terraform asks for confirmation.

## Destroy

When you no longer need the lab resources, run:

```bash
terraform destroy
```

Review the plan before confirming. NAT Gateway and Elastic IP resources can incur AWS charges.

## GitHub

The `.gitignore` file excludes `.terraform/`, state files and local variable files. Commit `.terraform.lock.hcl` after `terraform init` so provider selections are recorded.

Do not commit `terraform.tfstate`, `terraform.tfvars`, AWS credentials, private keys, or other secrets.

## Important note about an existing VPC

This configuration uses `10.0.0.0/16`. If you already created a VPC using `110.0.0.0/16`, do not run `terraform apply` with this new configuration against the same state without planning a migration. Terraform may propose replacing resources. Back up and review your existing state and plan first.
