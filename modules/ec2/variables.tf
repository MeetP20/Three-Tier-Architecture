variable "name" {
  type        = string
  description = "Name of the EC2 instance."
}

variable "vpc_id" {
  type        = string
  description = "VPC ID for the security group."
}

variable "subnet_id" {
  type        = string
  description = "Public subnet ID where the EC2 instance is deployed."
}

variable "ami_id" {
  type        = string
  description = "AMI ID for the EC2 instance."
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type."
  default     = "t3.micro"
}

variable "key_name" {
  type        = string
  description = "Existing EC2 key pair name."
  default     = null
}

variable "ssh_allowed_cidrs" {
  type        = list(string)
  description = "CIDR blocks allowed to SSH to the instance."
  default     = []
}

variable "user_data" {
  type        = string
  description = "Optional EC2 user-data script."
  default     = null
}