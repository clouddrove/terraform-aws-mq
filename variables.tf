# AWS Region where the broker will be deployed
variable "aws_region" {
  description = "The AWS region to deploy resources."
  type        = string
  default     = ""
}

# The name of the broker
variable "broker_name" {
  description = "The name of the broker."
  type        = string
  default     = ""
}

# The broker engine type (ActiveMQ, RabbitMQ, etc.)
variable "engine_type" {
  description = "The broker engine type."
  type        = string
  default     = ""
}

# The version of the broker engine
variable "engine_version" {
  description = "The version of the broker engine."
  type        = string
  default     = "5.18"
}

# The instance type of the broker (e.g., mq.t3.micro, mq.m5.large, etc.)
variable "host_instance_type" {
  description = "The instance type of the broker."
  type        = string
  default     = ""
}

# The deployment mode of the broker (SINGLE_INSTANCE or ACTIVE_STANDBY_MULTI_AZ)
variable "deployment_mode" {
  description = "The deployment mode of the broker. Supported: SINGLE_INSTANCE and ACTIVE_STANDBY_MULTI_AZ"
  type        = string
  default     = ""
}

# Maintenance day of the week for the broker
variable "maintenance_day_of_week" {
  description = "The day of the week for maintenance."
  type        = string
  default     = "Sun"
}

# Maintenance time of the day for the broker
variable "maintenance_time" {
  description = "The time of day for maintenance."
  type        = string
  default     = "13:05"
}

# The time zone for the maintenance window (e.g., UTC, EST, etc.)
variable "time_zone" {
  description = "The time zone for the maintenance window."
  type        = string
  default     = "UTC"
}

# Tags for the broker
variable "tags" {
  description = "Tags to apply to the broker."
  type        = map(string)
  default     = {}
}

# VPC CIDR block for the broker
variable "vpc_cidr_block" {
  description = "CIDR block for the VPC."
  type        = string
  default     = ""
}

# Subnet CIDR block for the broker
variable "subnet_cidr_block" {
  description = "CIDR block for the subnet."
  type        = string
  default     = ""
}

# Port for AMQP SSL
variable "amqp_ssl_port" {
  description = "Port for AMQP SSL."
  type        = number
  default     = 0
}

# Port for STOMP SSL
variable "stomp_ssl_port" {
  description = "Port for STOMP SSL."
  type        = number
  default     = 0
}

# CIDR blocks to allow for ingress traffic to the broker
variable "ingress_cidr_blocks" {
  description = "CIDR blocks to allow for ingress traffic."
  type        = list(string)
  default     = []
}

# Admin and Application user credentials
variable "mq_admin_user" {
  description = "Admin username for the MQ broker."
  type        = string
  default     = "admin"  
}

variable "mq_admin_password" {
  description = "Admin password for the MQ broker."
  type        = string
  sensitive   = true
  default     = ""  
}

variable "mq_application_username" {
  description = "Application username for the MQ broker."
  type        = string
  default     = "demo"  
}

variable "mq_application_password" {
  description = "Application password for the MQ broker."
  type        = string
  sensitive   = true
  default     = ""  
}
# Declare the variable for the application user
variable "mq_application_user" {
  description = "Username for the MQ application user"
  type        = string
  default     = "test"  # Leave default as empty string or set your own default
}
# Apply changes immediately or during the next maintenance window
variable "apply_immediately" {
  description = "Specifies whether any cluster modifications are applied immediately, or during the next maintenance window."
  type        = bool
  default     = false
}

# Enables automatic upgrades to new minor versions
variable "auto_minor_version_upgrade" {
  description = "Enables automatic upgrades to new minor versions for brokers, as Apache releases the versions."
  type        = bool
  default     = false
}

# Whether the broker should be publicly accessible
variable "publicly_accessible" {
  description = "Whether to enable connections from applications outside of the VPC that hosts the broker's subnets."
  type        = bool
  default     = false
}

# Enable/disable general logging via CloudWatch
variable "general_log_enabled" {
  description = "Enables general logging via CloudWatch."
  type        = bool
  default     = false
}

# Enable/disable audit logging for user management actions
variable "audit_log_enabled" {
  description = "Enables audit logging. User management actions made using JMX or the ActiveMQ Web Console are logged."
  type        = bool
  default     = false
}

# Maintenance time of day for the broker in 24-hour format (e.g., 03:00)
variable "maintenance_time_of_day" {
  description = "The maintenance time, in 24-hour format. e.g. 02:00"
  type        = string
  default     = "06:00"
}

# Maintenance time zone for the broker
variable "maintenance_time_zone" {
  description = "The maintenance time zone, in either the Country/City format, or the UTC offset format. e.g. CET"
  type        = string
  default     = "UTC"
}

# VPC ID for the broker
variable "vpc_id" {
  description = "The ID of the VPC to create the broker in."
  type        = string
  default     = ""
}

# Subnet IDs for the broker
variable "subnet_ids" {
  description = "List of VPC subnet IDs."
  type        = list(string)
  default     = []
}

# Format for SSM parameter names
variable "ssm_parameter_name_format" {
  description = "SSM parameter name format"
  type        = string
  default     = "%s%s"
}

# Path to be used in the SSM parameter name
variable "ssm_path" {
  description = "The first parameter to substitute in `ssm_parameter_name_format`"
  type        = string
  default     = "/myapp"
}



# SSM parameter name for Admin username
variable "mq_admin_user_ssm_parameter_name" {
  description = "SSM parameter name for Admin username."
  type        = string
  default     = ""
}

# SSM parameter name for Admin password
variable "mq_admin_password_ssm_parameter_name" {
  description = "SSM parameter name for Admin password."
  type        = string
  default     = ""
}

# SSM parameter name for Application username
variable "mq_application_user_ssm_parameter_name" {
  description = "SSM parameter name for Application username."
  type        = string
  default     = ""
}

# SSM parameter name for Application password
variable "mq_application_password_ssm_parameter_name" {
  description = "SSM parameter name for Application password."
  type        = string
  default     = ""
}

# ARN of the KMS key used for SSM encryption
variable "kms_ssm_key_arn" {
  description = "ARN of the AWS KMS key used for SSM encryption."
  type        = string
  default     = ""
}

# Flag to enable or disable Amazon MQ encryption
variable "encryption_enabled" {
  description = "Flag to enable/disable Amazon MQ encryption at rest."
  type        = bool
  default     = false
}

# ARN of the KMS key used for MQ encryption
variable "kms_mq_key_arn" {
  description = "ARN of the AWS KMS key used for Amazon MQ encryption."
  type        = string
  default     = ""
}

# Flag to use AWS owned KMS CMK for MQ encryption
variable "use_aws_owned_key" {
  description = "Boolean to enable an AWS owned Key Management Service (KMS) Customer Master Key (CMK) for Amazon MQ encryption."
  type        = bool
  default     = false
}

# List of allowed TCP ports for ingress traffic
variable "allowed_ingress_ports" {
  description = "List of TCP ports to allow access to in the created security group."
  type        = list(number)
  default     = []
}
variable "alias" {
  description = "The alias name for the KMS key"
  type        = string
  default     = "update" 
}

# List of additional security group IDs to associate with the broker
variable "additional_security_group_ids" {
  description = "List of additional security group IDs to associate with the broker."
  type        = list(string)
  default     = []
}

# List of groups the MQ admin user will belong to
variable "mq_admin_groups" {
  description = "List of groups the MQ admin user will belong to."
  type        = list(string)
  default     = [] 
}

# Whether the MQ admin user should have console access
variable "console_access" {
  description = "Whether the MQ admin user should have console access."
  type        = bool
  default     = false
}

# List of MQ broker names
variable "mq_broker_name" {
  description = "The name of the MQ broker."
  type        = string
  default     = "my-mq-broker"
}

# ARN of the KMS key for encryption purposes in other places (optional)
variable "kms_key_arn" {
  description = "ARN of the AWS KMS key for encryption."
  type        = string
  default     = ""
}
# Variable to allow bypassing the KMS policy lockout safety check
variable "bypass_policy_lockout_safety_check" {
  description = "Flag to bypass KMS policy lockout safety check."
  type        = bool
  default     = false
}

# Variable to specify if the KMS key should be multi-region
variable "multi_region" {
  description = "Flag to indicate if the KMS key is multi-region."
  type        = bool
  default     = false
}

# Variable for KMS key policy
variable "policy" {
  description = "The KMS key policy in JSON format."
  type        = string
  default     = ""
}

# Variable for the Customer Master Key (CMK) spec (e.g., ECC, RSA, etc.)
variable "customer_master_key_spec" {
  description = "The customer master key (CMK) spec for KMS key."
  type        = string
  default     = "SYMMETRIC_DEFAULT"
}

# Variable to enable key rotation for KMS keys
variable "enable_key_rotation" {
  description = "Flag to enable automatic key rotation for the KMS key."
  type        = bool
  default     = true
}

# Variable to specify the deletion window for KMS keys in days
variable "deletion_window_in_days" {
  description = "The window of time, in days, before a KMS key is deleted."
  type        = number
  default     = 30
}

# Flag to indicate if the KMS key is enabled or not
variable "kms_key_enabled" {
  description = "Flag to enable or disable the KMS key."
  type        = bool
  default     = true
}

# Variable for the description of the KMS key
variable "description" {
  description = "Description of the KMS key."
  type        = string
  default     = "Default KMS Key"
}
# Key Usage for KMS Key
variable "key_usage" {
  description = "Specifies the intended use of the KMS key (ENCRYPT_DECRYPT, GENERATE_VERIFY_MAC, etc.)."
  type        = string
  default     = "ENCRYPT_DECRYPT"  # Common default for symmetric keys
}

# Flag to enable or disable the resource
variable "enabled" {
  description = "Flag to enable or disable the creation of the resource."
  type        = bool
  default     = true  # Default to true if you want to enable by default
}
variable "enable_cloudwatch_logs" {
  description = "Enable CloudWatch logs for MQ broker"
  type        = bool
  default     = true
}

variable "cloudwatch_log_group_name" {
  description = "The name of the CloudWatch log group"
  type        = string
  default     = "/aws/mq/logs"
}

variable "cloudwatch_log_retention_days" {
  description = "The retention period (in days) for CloudWatch logs"
  type        = number
  default     = 7  # Retain logs for 7 days
}
variable "use_secrets_manager" {
  description = "Flag to determine if Secrets Manager should be used for storing passwords."
  type        = bool
  default     = false  # Set to true if you want to use Secrets Manager
}

variable "secret_manager_key_prefix" {
  description = "Prefix for Secrets Manager secret keys."
  type        = string
  default     = "/aws/mq"  # Default value, adjust based on your use case
}

# variable "general_log_enabled" {
#   description = "Enable general MQ broker logs"
#   type        = bool
#   default     = true
# }

# variable "audit_log_enabled" {
#   description = "Enable audit logs for MQ broker"
#   type        = bool
#   default     = true
# }

# variable "tags" {
#   description = "Tags to be applied to resources"
#   type        = map(string)
#   default     = {}
# }
variable "security_group_id" {
  description = "Security group ID to associate with the MQ broker"
  type        = list
  default     = [""]  # Default to an empty string, not an empty list
}
