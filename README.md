# AWS Three-Tier Architecture with Terraform

A modular Terraform project that provisions the **networking foundation for a three-tier AWS architecture**, including a public EC2 web tier and a private PostgreSQL RDS database tier.

The project demonstrates reusable Terraform modules, public/private subnet isolation, Internet Gateway routing, and security-group based EC2-to-RDS access.

## Architecture

```text
                         Internet
                            │
                            ▼
                    Internet Gateway
                            │
              ┌─────────────┴─────────────┐
              │                           │
        Public Subnet A             Public Subnet B
              │                           │
           EC2 Web                  Reserved for
              │                    future web tier
              │
              │ TCP 5432
              ▼
        ┌──────────────────────────────────┐
        │         Private Subnets          │
        │                                  │
        │       RDS Subnet Group           │
        │              │                   │
        │              ▼                   │
        │      PostgreSQL RDS              │
        └──────────────────────────────────┘
```

The architecture uses two Availability Zones for the subnet layout. The EC2 instance is deployed in a public subnet, while RDS is deployed into private subnets and is **not publicly accessible**.

> **NAT Gateway is not required for the current workload.** RDS does not need NAT to communicate with EC2. NAT is only needed when a private resource requires outbound Internet access. It can be added later when a private application tier is introduced.

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
- Public and private route tables
- Route table associations
- Optional NAT Gateway support for future private workloads

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

## Network and Security Model

The current application-to-database flow is entirely inside the VPC:

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

The RDS security group permits PostgreSQL traffic **only from the EC2 security group**.

RDS is configured as:

```hcl
publicly_accessible = false
```

This means the database does not have a public endpoint accessible directly from the Internet.

SSH access to EC2 should also be restricted to your own IP address rather than opening port 22 to the world.

## Why NAT Gateway Is Optional

NAT Gateway is deliberately **not required by the current architecture**.

RDS does not need Internet access to receive database connections from EC2. The EC2-to-RDS connection uses private VPC networking and security groups.

NAT becomes useful when private resources need outbound Internet access, for example:

```text
Private Application EC2
          │
          ▼
     NAT Gateway
          │
          ▼
       Internet
```

A future version of this project can add a private application tier and enable NAT for that tier.

## Prerequisites

Install:

- Terraform >= 1.6
- AWS CLI
- An AWS account with permissions to create VPC, EC2 and RDS resources

Verify AWS authentication:

```bash
aws sts get-caller-identity
```

The AWS provider uses the standard AWS credential chain. **Do not hard-code AWS access keys in Terraform files.**

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

Example architecture values:

```text
VPC:             10.0.0.0/16
Public subnets:  10.0.1.0/24, 10.0.2.0/24
Private subnets: 10.0.11.0/24, 10.0.12.0/24
EC2:             t3.micro
RDS:             PostgreSQL / db.t3.micro
NAT:             Disabled for the current workload
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

> RDS can incur AWS charges. Review the Terraform plan carefully before destroying production resources.

## Why Modules?

The infrastructure is split into reusable modules instead of keeping all resources in the root configuration.

This makes the project easier to:

- Reuse across environments
- Change networking independently from compute and database resources
- Pass outputs between infrastructure layers
- Maintain individual infrastructure components
- Extend with additional modules such as ALB, Auto Scaling, IAM or monitoring

## Future Improvements

- Add an Application Load Balancer in front of EC2
- Add an Auto Scaling Group for the web tier
- Add a private application tier
- Enable NAT Gateway when private workloads require outbound Internet access
- Add separate security groups for web, application and database tiers
- Enable RDS Multi-AZ for production environments
- Add VPC endpoints
- Add CloudWatch monitoring and alarms
- Add remote Terraform state with S3
- Add CI/CD with Terraform format, validation, plan and security scanning
- Add automated tests for Terraform modules

## Skills Demonstrated

**AWS:** VPC, EC2, RDS, Internet Gateway, Security Groups, subnet and routing design

**Terraform:** Reusable modules, variables, outputs, resource dependencies, Infrastructure as Code

**Networking:** Public/private subnet design, routing, VPC connectivity, security-group based access control

## License

This project is intended for learning and portfolio demonstration purposes.
