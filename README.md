# AWS Three-Tier Architecture with Terraform

A modular Terraform project that provisions a **three-tier AWS architecture** with reusable modules for networking, a public EC2 web tier, and a private PostgreSQL RDS database tier.

The project demonstrates Infrastructure as Code, reusable Terraform modules, public/private subnet isolation, NAT Gateway based egress, and security-group based application-to-database access.

## Architecture

```text
                           Internet
                              │
                              ▼
                       Internet Gateway
                              │
              ┌───────────────┴───────────────┐
              │                               │
        Public Subnet A                 Public Subnet B
              │                               │
           EC2 Web                      NAT Gateway
              │                               │
              │                         Private Subnet B
              │                               │
              │                          RDS Subnet
              │                               │
              └─────── PostgreSQL ───────────┘
                              │
                         Private RDS
```

The Terraform configuration creates two Availability Zones by default. Public subnets host internet-facing compute, while RDS is placed in private subnets through an RDS subnet group.

## Terraform Modules

```text
.
├── main.tf
├── variables.tf
├── outputs.tf
├── providers.tf
├── terraform.tfvars.example
│
└── modules/
    ├── vpc/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    │
    ├── ec2/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    │
    └── rds/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

### VPC Module

Creates:

- VPC
- Public subnets
- Private subnets
- Internet Gateway
- NAT Gateways
- Public and private route tables
- Route table associations

### EC2 Module

Creates a configurable EC2 instance in a public subnet with:

- Security group
- SSH access restricted through configurable CIDRs
- HTTP access
- Public IP
- Optional user-data bootstrap

### RDS Module

Creates a PostgreSQL RDS instance in private subnets with:

- DB subnet group
- Private RDS instance
- Dedicated database security group
- Database access allowed only from the EC2 security group
- Automated backup retention
- Optional Multi-AZ deployment

## Security Model

The database is intentionally not exposed to the public internet:

```text
Internet
   │
   ▼
Public EC2
   │
   │ TCP 5432
   ▼
Private RDS
```

The RDS security group permits PostgreSQL traffic only from the EC2 security group. RDS is configured with:

```hcl
publicly_accessible = false
```

SSH access to EC2 should also be restricted to your own IP address rather than opening port 22 to the world.

## Prerequisites

Install:

- Terraform >= 1.6
- AWS CLI
- An AWS account with permissions to create VPC, EC2, NAT Gateway, IAM-related and RDS resources

Verify AWS authentication:

```bash
aws sts get-caller-identity
```

The AWS provider uses the standard AWS credential chain. Do not hard-code AWS access keys in Terraform files.

## Configuration

Copy the example variables file:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Update at minimum:

- `ami_id`
- `key_name`
- `ssh_allowed_cidrs`
- `db_username`
- `db_password`

Do not commit `terraform.tfvars` or real database credentials.

The example uses:

```text
VPC:             10.0.0.0/16
Public subnets:  10.0.1.0/24, 10.0.2.0/24
Private subnets: 10.0.11.0/24, 10.0.12.0/24
EC2:             t3.micro
RDS:             PostgreSQL / db.t3.micro
```

## Deployment

Initialize Terraform:

```bash
terraform init
```

Format the configuration:

```bash
terraform fmt -recursive
```

Validate the configuration:

```bash
terraform validate
```

Review the execution plan:

```bash
terraform plan
```

Apply the infrastructure:

```bash
terraform apply
```

## Useful Outputs

After deployment:

```bash
terraform output
```

Important outputs include:

- VPC ID
- Public subnet IDs
- Private subnet IDs
- EC2 instance ID
- EC2 public IP
- Private RDS endpoint

## Cleanup

Destroy all resources when finished:

```bash
terraform destroy
```

> NAT Gateways and RDS can incur AWS charges. Destroy the environment when it is no longer required.

## Why Modules?

The infrastructure is intentionally split into reusable modules instead of keeping all resources in the root configuration.

This makes the project easier to:

- Reuse across environments
- Change networking independently from compute and database resources
- Pass outputs between infrastructure layers
- Maintain and test individual infrastructure components
- Extend with additional modules such as ALB, Auto Scaling, IAM or monitoring

## Future Improvements

- Add an Application Load Balancer in front of EC2
- Add an Auto Scaling Group for the web tier
- Add separate security groups for web, application and database tiers
- Enable RDS Multi-AZ by default for production environments
- Add VPC endpoints
- Add CloudWatch monitoring and alarms
- Add remote Terraform state with S3
- Add CI/CD with Terraform format, validation, plan and security scanning
- Add automated tests for Terraform modules

## Skills Demonstrated

**AWS:** VPC, EC2, RDS, Internet Gateway, NAT Gateway, Security Groups

**Terraform:** Modules, variables, outputs, resource dependencies, Infrastructure as Code

**Networking:** Public/private subnet design, routing, NAT, security-group based access control

## License

This project is intended for learning and portfolio demonstration purposes.
