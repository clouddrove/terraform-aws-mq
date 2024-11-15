variable "aws_region" {
  description = "The AWS region to deploy resources."
  type        = string
  default     = "us-west-1" # Modify based on your region
}

# variable "availability_zones" {
#   description = "List of availability zones in the AWS region."
#   type        = list(string)
#   default     = ["us-east-1a"] # Adjust to match your region's AZs
# }


variable "mq_broker_name" {
  description = "The name of the MQ broker."
  type        = string
  default     = "my-mq-broker"
}

variable "engine_type" {
  description = "The engine type for the MQ broker."
  type        = string
  default     = "ACTIVEMQ"
}

variable "engine_version" {
  description = "The version of the engine for the MQ broker."
  type        = string
  default     = "5.18"
}

variable "host_instance_type" {
  description = "The instance type of the broker."
  type        = string
  default     = "mq.t3.micro"
}

variable "deployment_mode" {
  description = "The deployment mode of the broker (SINGLE_INSTANCE or ACTIVE_STANDBY_MULTI_AZ)."
  type        = string
  default     = "SINGLE_INSTANCE"
}

# Admin and Application user credentials
variable "mq_admin_user" {
  description = "Admin username for the MQ broker."
  type        = string
  default     = "admin_user"
}

variable "mq_admin_password" {
  description = "Admin password for the MQ broker."
  type        = string
  sensitive   = true
  default     = "admin_password"
}

variable "mq_application_username" {
  description = "Application username for the MQ broker."
  type        = string
  default     = "app_user"
}

variable "mq_application_password" {
  description = "Application password for the MQ broker."
  type        = string
  sensitive   = true
  default     = "app_password"
}

# VPC settings
variable "vpc_id" {
  description = "The VPC ID where the MQ broker should be deployed."
  type        = string
  default     = "bcd"
}

variable "subnet_ids" {
  description = "List of subnet IDs where the MQ broker should be deployed."
  type        = list(string)
  default     = ["subnet-abc123"]
}

# Tags and other settings for the broker
variable "tags" {
  description = "Tags to apply to the MQ broker."
  type        = map(string)
  default     = {}
}

# Encryption and security settings
variable "encryption_enabled" {
  description = "Flag to enable encryption at rest for the broker."
  type        = bool
  default     = false
}

variable "kms_mq_key_arn" {
  description = "The ARN of the KMS key for MQ broker encryption."
  type        = string
  default     = ""
}

variable "allowed_ingress_ports" {
  description = "List of TCP ports to allow access to in the created security group."
  type        = list(number)
  default     = []
}

variable "additional_security_group_ids" {
  description = "List of additional security group IDs to associate with the broker."
  type        = list(string)
  default     = []
}
# variable "mq_admin_user_ssm_parameter_name" {
#   description = "SSM parameter name for Admin username."
#   type        = string
#   default     = "user1"
# }
# Maintenance and update settings
variable "apply_immediately" {
  description = "Whether to apply changes immediately."
  type        = bool
  default     = false
}

variable "auto_minor_version_upgrade" {
  description = "Whether to enable automatic minor version upgrades."
  type        = bool
  default     = true
}
variable "new_sg" {
  description = "Whether to create a new security group"
  type        = bool
  default     = true # Ensure this is true if you want the security group created
}

variable "enable" {
  description = "Whether to enable security group"
  type        = bool
  default     = true # Ensure this is true if you want the security group to be enabled
}


variable "publicly_accessible" {
  description = "Whether the broker should be publicly accessible."
  type        = bool
  default     = false
}

variable "general_log_enabled" {
  description = "Enable general logging for the broker."
  type        = bool
  default     = false
}

variable "audit_log_enabled" {
  description = "Enable audit logging for the broker."
  type        = bool
  default     = false
}

# Declare variable for broker_name
variable "broker_name" {
  description = "The name of the broker."
  type        = string
  default     = "example-broker" # You can set a default value or leave it empty
}

# Declare variable for maintenance_time
variable "maintenance_time" {
  description = "The time of day for maintenance."
  type        = string
  default     = "03:00" # Set a default time for maintenance, in 24-hour format
}

# Declare variable for time_zone
variable "time_zone" {
  description = "The time zone for the maintenance window."
  type        = string
  default     = "UTC" # Default time zone, change if needed
}

# Optionally, declare other variables used in your example.tf
# variable "aws_region" {
#   description = "The AWS region to deploy resources."
#   type        = string
#   default     = "eu-north-1"  # Set default region
# }

# Declare additional variables as necessary for your resources
# Declare variable for maintenance_day_of_week
variable "maintenance_day_of_week" {
  description = "The day of the week for maintenance."
  type        = string
  default     = "Sunday" # Example default value, modify based on your need
}

# Declare variable for use_aws_owned_key
variable "use_aws_owned_key" {
  description = "Boolean flag to use AWS owned KMS key for MQ encryption."
  type        = bool
  default     = false # Set default to false (change as needed)
}

# Declare variable for ssm_path
variable "ssm_path" {
  description = "The first parameter to substitute in `ssm_parameter_name_format`"
  type        = string
  default     = "/test-ssm"
}

# Declare variable for kms_ssm_key_arn
variable "kms_ssm_key_arn" {
  description = "The ARN of the KMS key for encrypting SSM parameters."
  type        = string
  default     = "" # Default is an empty string, can be updated with the actual ARN
}
variable "alias" {
  description = "The alias name for the KMS key"
  type        = string
  default     = "kms-demo"
}
# CloudWatch Logs settings
variable "enable_cloudwatch_logs" {
  description = "Enable CloudWatch logs for MQ broker"
  type        = bool
  default     = true  # Default to true to enable CloudWatch logs
}

variable "cloudwatch_log_group_name" {
  description = "The name of the CloudWatch log group"
  type        = string
  default     = "/aws/mq/logs"  # Default log group name
}

variable "cloudwatch_log_retention_days" {
  description = "The retention period (in days) for CloudWatch logs"
  type        = number
  default     = 7  # Default retention period for logs in days
}

# Secrets Manager configuration
variable "use_secrets_manager" {
  description = "Flag to determine if Secrets Manager should be used for storing passwords."
  type        = bool
  default     = true  # Default to true, to use Secrets Manager
}

variable "secret_manager_key_prefix" {
  description = "Prefix for Secrets Manager key names."
  type        = string
  default     = "mq"  # Default key prefix for Secrets Manager
}
