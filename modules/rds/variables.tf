variable "name" {
  type        = string
  description = "RDS instance identifier and name prefix."
}

variable "vpc_id" {
  type        = string
  description = "VPC ID containing the RDS instance."
}

variable "subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs for the RDS subnet group."
}

variable "application_security_group_id" {
  type        = string
  description = "Security group ID allowed to access the database."
}

variable "engine" {
  type        = string
  description = "RDS database engine."
  default     = "postgres"
}

variable "db_name" {
  type        = string
  description = "Initial database name."
  default     = "appdb"
}

variable "username" {
  type        = string
  description = "Master username."
  sensitive   = true
}

variable "password" {
  type        = string
  description = "Master password. Store this securely outside Git."
  sensitive   = true
}

variable "port" {
  type        = number
  description = "Database port."
  default     = 5432
}

variable "instance_class" {
  type        = string
  description = "RDS instance class."
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  type        = number
  description = "Allocated storage in GiB."
  default     = 20
}

variable "backup_retention_period" {
  type        = number
  description = "Number of days to retain automated backups."
  default     = 7
}

variable "multi_az" {
  type        = bool
  description = "Enable Multi-AZ deployment."
  default     = false
}