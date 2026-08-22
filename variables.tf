variable "name" {
  description = "Name prefix for the environment."
  type        = string
  default     = "three-tier"
}

variable "vpc_cidr" {
  description = "VPC CIDR block."
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability Zones used for the architecture."
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDRs."
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "enable_nat_gateway" {
  description = "Create one NAT Gateway per public subnet."
  type        = bool
  default     = true
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance. Use an AMI valid for the selected AWS region."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Existing EC2 key pair name."
  type        = string
  default     = null
}

variable "ssh_allowed_cidrs" {
  description = "CIDRs allowed to SSH to the public EC2 instance. Restrict this to your IP."
  type        = list(string)
  default     = []
}

variable "user_data" {
  description = "Optional EC2 user-data script."
  type        = string
  default     = null
}

variable "db_engine" {
  description = "RDS engine."
  type        = string
  default     = "postgres"
}

variable "db_name" {
  description = "Initial database name."
  type        = string
  default     = "appdb"
}

variable "db_username" {
  description = "RDS master username."
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "RDS master password. Never commit this value to Git."
  type        = string
  sensitive   = true
}

variable "db_port" {
  description = "Database port."
  type        = number
  default     = 5432
}

variable "db_instance_class" {
  description = "RDS instance class."
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "RDS allocated storage in GiB."
  type        = number
  default     = 20
}

variable "db_backup_retention_period" {
  description = "Automated backup retention in days."
  type        = number
  default     = 7
}

variable "db_multi_az" {
  description = "Enable RDS Multi-AZ deployment."
  type        = bool
  default     = false
}