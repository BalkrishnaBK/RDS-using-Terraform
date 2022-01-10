
##################################################################################
# MODULES
##################################################################################

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "~> 3.10.0"

  name = "${var.name_prefix}-vpc"
  cidr = var.vpc_db_cidr_block

  azs             = slice(data.aws_availability_zones.available.names, 0, (var.vpc_subnet_count))
#   private_subnets = [for subnet in range(var.vpc_subnet_count) : cidrsubnet(var.vpc_pri_cidr_block, 8, subnet)]
#   public_subnets  = [for subnet in range(var.vpc_subnet_count) : cidrsubnet(var.vpc_pub_cidr_block, 8, subnet)]
  database_subnets = [for subnet in range(var.vpc_subnet_count) : cidrsubnet(var.vpc_db_cidr_block, 8, subnet)]

  enable_nat_gateway = false
  enable_vpn_gateway = false
  tags = merge(local.tags,{
    Name = "${var.name_prefix}"    
    VPC  = "${var.name_prefix}-vpc" 
  },
  )
}

module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 3.0"

  identifier = "${var.name_prefix}-rds"

  engine            = "mysql"
  engine_version    = "5.7.19"
  instance_class    = "db.t2.large"
  allocated_storage = 5

  name     = var.name_prefix
  username = var.user_name
  password = var.pass_word
  port     = local.port

  iam_database_authentication_enabled = true
  multi_az               = true
  subnet_ids             = module.vpc.database_subnets

  vpc_security_group_ids = [module.vpc.default_security_group_id]

  # DB parameter group
  family = "mysql5.7"

  # DB option group
  major_engine_version = "5.7"

  # Database Deletion Protection
  deletion_protection = false

  tags = merge(local.tags,{
    Name = "${var.name_prefix}"
    EKS  = "${var.name_prefix}-db"    
  },
  )

}