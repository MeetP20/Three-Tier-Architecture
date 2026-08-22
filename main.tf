module "vpc" {
  source = "./modules/vpc"

  name                 = var.name
  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  enable_nat_gateway   = var.enable_nat_gateway
}

module "ec2" {
  source = "./modules/ec2"

  name               = "${var.name}-web"
  vpc_id             = module.vpc.vpc_id
  subnet_id          = module.vpc.public_subnet_ids[0]
  ami_id             = var.ami_id
  instance_type      = var.instance_type
  key_name           = var.key_name
  ssh_allowed_cidrs  = var.ssh_allowed_cidrs
  user_data          = var.user_data
}

module "rds" {
  source = "./modules/rds"

  name                         = "${var.name}-db"
  vpc_id                       = module.vpc.vpc_id
  subnet_ids                   = module.vpc.private_subnet_ids
  application_security_group_id = module.ec2.security_group_id

  engine                  = var.db_engine
  db_name                 = var.db_name
  username                = var.db_username
  password                = var.db_password
  port                    = var.db_port
  instance_class          = var.db_instance_class
  allocated_storage       = var.db_allocated_storage
  backup_retention_period = var.db_backup_retention_period
  multi_az                = var.db_multi_az
}