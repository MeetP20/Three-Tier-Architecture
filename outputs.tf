output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "VPC ID."
}

output "public_subnet_ids" {
  value       = module.vpc.public_subnet_ids
  description = "Public subnet IDs."
}

output "private_subnet_ids" {
  value       = module.vpc.private_subnet_ids
  description = "Private subnet IDs."
}

output "ec2_instance_id" {
  value       = module.ec2.instance_id
  description = "Public EC2 instance ID."
}

output "ec2_public_ip" {
  value       = module.ec2.public_ip
  description = "Public IP of the EC2 instance."
}

output "rds_endpoint" {
  value       = module.rds.endpoint
  description = "Private RDS endpoint."
}

output "rds_address" {
  value       = module.rds.address
  description = "Private RDS hostname."
}