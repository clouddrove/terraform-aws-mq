provider "aws" {
  region = var.aws_region
}

locals {
  name        = "app"
  environment = "test"
  label_order = ["name", "environment"]
}

# Define VPC module
module "vpc" {
  source      = "clouddrove/vpc/aws"
  version     = "2.0.0"
  name        = local.name
  environment = local.environment
  cidr_block  = "10.0.0.0/16"
}

# Define Security Group module
# module "security_group" {
#   source      = "clouddrove/security-group/aws"
#   version     = "2.0.0"
#   name        = local.name
#   environment = local.environment
#   vpc_id      = module.vpc.vpc_id
module "security_group" {
  source  = "clouddrove/security-group/aws"
  version = "2.0.0"

  name        = local.name
  environment = local.environment
  vpc_id      = module.vpc.vpc_id

  ## INGRESS Rules
  new_sg_ingress_rules_with_cidr_blocks = [
    {
      rule_count  = 1
      from_port   = 5432
      protocol    = "tcp"
      to_port     = 5432
      cidr_blocks = [module.vpc.vpc_cidr_block]
      description = "Allow PostgreSQL traffic."
    }
  ]
  new_sg_egress_rules_with_cidr_blocks = [
    {
      rule_count  = 1
      from_port   = 0
      protocol    = "-1"
      to_port     = 0
      cidr_blocks = [module.vpc.vpc_cidr_block]
      description = "Allow all outbound traffic within the VPC."
    }
  ]



  ## EGRESS Rules
  # new_sg_egress_rules_with_cidr_blocks = [
  #   {
  #     rule_count  = 1
  #     from_port   = 0
  #     protocol    = "-1"
  #     to_port     = 0
  #     cidr_blocks = ["0.0.0.0/0"]
  #     description = "Allow all outbound traffic."
  #   }
  # ]

}


# Define Subnet module
# module "public_subnet" {
#   source             = "clouddrove/subnet/aws"
#   version            = "2.0.1"
#   name               = "public-subnet"
#   environment        = local.environment
#   label_order        = local.label_order
#   availability_zones = ["us-west-1b", "us-west-1c"]
#   vpc_id             = module.vpc.vpc_id
#   cidr_block         = module.vpc.vpc_cidr_block
#   type               = "public"
#   igw_id             = module.vpc.igw_id
#   ipv6_cidr_block    = module.vpc.ipv6_cidr_block
#   public_inbound_acl_rules = [
#     {
#       rule_number = 100
#       rule_action = "deny"
#       from_port   = 5432
#       to_port     = 5432
#       protocol    = "tcp"
#       cidr_block  = "10.0.1.0/24"
#     },
#   ]
#   private_inbound_acl_rules = [
#     {
#       rule_number = 100
#       rule_action = "deny"
#       from_port   = 0
#       to_port     = 0
#       protocol    = "-1"
#       cidr_block  = "10.0.2.0/24"
#     },
#   ]
# }


module "public_subnet" {
  source             = "clouddrove/subnet/aws"
  version            = "2.0.1"
  name               = "public-subnet"
  environment        = local.environment
  label_order        = local.label_order
  availability_zones = ["us-west-1b", "us-west-1c"]
  vpc_id             = module.vpc.vpc_id
  cidr_block         = module.vpc.vpc_cidr_block
  type               = "public"
  igw_id             = module.vpc.igw_id
  ipv6_cidr_block    = module.vpc.ipv6_cidr_block

  # Define specific inbound ACL rules for public subnet
  public_inbound_acl_rules = [
    {
      rule_number = 100
      rule_action = "deny"
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      cidr_block  = "10.0.1.0/24"
    },
    {
      rule_number = 110
      rule_action = "allow"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_block  = "0.0.0.0/0"  # Allow HTTP traffic from anywhere
    },
    {
      rule_number = 120
      rule_action = "allow"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_block  = "0.0.0.0/0"  # Allow HTTPS traffic from anywhere
    }
  ]

  # Define specific private inbound ACL rules if needed, or omit if unnecessary
  private_inbound_acl_rules = [
    {
      rule_number = 100
      rule_action = "deny"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_block  = "10.0.2.0/24"
    }
  ]
}


# Define MQ Broker module
module "mq_broker" {
  source = "../.." # Reference the path of the root module where the MQ broker is defined

  # Pass in the values to configure the MQ broker
  aws_region              = var.aws_region
  mq_broker_name          = var.mq_broker_name
  engine_type             = var.engine_type
  engine_version          = var.engine_version
  host_instance_type      = var.host_instance_type
  broker_name             = var.broker_name
  deployment_mode         = var.deployment_mode
  maintenance_day_of_week = var.maintenance_day_of_week
  maintenance_time        = var.maintenance_time
  tags                    = var.tags


  # Pass in the VPC and Subnet created by the VPC and Subnet modules
  vpc_id = module.vpc.vpc_id # Pass VPC ID
  #  subnet_ids                  = module.public_subnet.public_subnet_id
  subnet_ids = [module.public_subnet.public_subnet_id[0]]
  # Pass subnet IDs
  security_group_id = [module.security_group.security_group_id]
  # MQ broker-specific settings
  apply_immediately             = var.apply_immediately
  auto_minor_version_upgrade    = var.auto_minor_version_upgrade
  publicly_accessible           = var.publicly_accessible
  general_log_enabled           = var.general_log_enabled
  audit_log_enabled             = var.audit_log_enabled
  kms_mq_key_arn                = var.kms_mq_key_arn
  use_aws_owned_key             = var.use_aws_owned_key
  ssm_path                      = var.ssm_path
  encryption_enabled            = var.encryption_enabled
  kms_ssm_key_arn               = var.kms_ssm_key_arn
  allowed_ingress_ports         = var.allowed_ingress_ports
  additional_security_group_ids = var.additional_security_group_ids

  # Admin and Application user credentials
  mq_admin_user           = var.mq_admin_user
  mq_admin_password       = var.mq_admin_password
  mq_application_user     = var.mq_application_username
  mq_application_password = var.mq_application_password
  alias = format(
    "alias/%s",
    replace(var.alias, "[^a-zA-Z0-9_-]", "_")
  )
}
output "security_group_id" {
  value       = module.security_group.security_group_id
  description = "The Security Group ID"
}

output "subnet_ids" {
  value       = module.public_subnet.public_subnet_id
  description = "The IDs of the subnets created."
}



