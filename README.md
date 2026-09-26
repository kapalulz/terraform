# Terraform on AWS — Practice Lab

A collection of progressive Terraform exercises covering core AWS infrastructure patterns.

## Topics covered

- EC2 compute
- VPC networking and Internet Gateways
- Public and private subnets
- NAT and routing
- RDS
- Load balancing and Auto Scaling
- CloudFront
- Reusable Terraform modules
- Global and environment-specific variables

## Repository layout

The `lesson-*` directories contain focused exercises. Larger end-to-end examples live in `Big one/` and the root-level architecture configuration.

Because the repository contains multiple independent labs, run Terraform from the directory for the exercise you are reviewing:

```bash
cd lesson-6
terraform init
terraform fmt -check
terraform validate
terraform plan
```

## Requirements

- Terraform
- An AWS account
- AWS authentication configured through an environment, profile, or assigned IAM role

## Safety

Read each exercise before applying it. Several examples can create billable resources such as NAT Gateways, load balancers, databases, and CloudFront distributions.

Never commit AWS credentials or Terraform state. Destroy lab environments when finished:

```bash
terraform destroy
```

> These configurations are educational examples rather than a single production-ready stack.
