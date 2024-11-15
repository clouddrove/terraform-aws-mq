# ------------------------------------------------------------------------------
# Resources
# ------------------------------------------------------------------------------
locals {
  label_order = var.label_order
}

# Fetch existing SSM Parameters for MQ Application and Admin users
data "aws_ssm_parameter" "mq_application_username" {
  count = var.mq_application_user_ssm_parameter_name != "" && var.use_secrets_manager ? 1 : 0
  name  = var.mq_application_user_ssm_parameter_name
}

data "aws_ssm_parameter" "mq_application_password" {
  count = var.mq_application_password_ssm_parameter_name != "" && var.use_secrets_manager ? 1 : 0
  name  = var.mq_application_password_ssm_parameter_name
}

data "aws_ssm_parameter" "mq_master_username" {
  count = var.mq_admin_user_ssm_parameter_name != "" && var.use_secrets_manager ? 1 : 0
  name  = var.mq_admin_user_ssm_parameter_name
}

data "aws_ssm_parameter" "mq_master_password" {
  count = var.mq_admin_password_ssm_parameter_name != "" && var.use_secrets_manager ? 1 : 0
  name  = var.mq_admin_password_ssm_parameter_name
}

# Call the Clouddrove KMS module to create the KMS key if enabled
module "kms" {
  source      = "clouddrove/kms/aws"
  enabled     = var.kms_key_enabled
  description = "KMS key for MQ"
  key_usage   = "ENCRYPT_DECRYPT"
  alias = format(
    "alias/%s",
    replace(var.alias, "[^a-zA-Z0-9_-]", "_")
  )
  enable_key_rotation = true
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = "kms:*"
        Effect   = "Allow"
        Resource = "*"
        Principal = {
          AWS = "*"
        }
      }
    ]
  })
}

# Store Secrets in Secrets Manager or fallback to SSM based on flag
resource "aws_secretsmanager_secret" "mq_master_username_secret" {
  count       = var.use_secrets_manager && var.mq_admin_user != "" ? 1 : 0
  name        = "${var.secret_manager_key_prefix}/admin/username"
  description = "MQ Admin Username"
  tags        = var.tags
}

resource "aws_secretsmanager_secret_version" "mq_master_username_version" {
  count     = var.use_secrets_manager && var.mq_admin_user != "" ? 1 : 0
  secret_id = aws_secretsmanager_secret.mq_master_username_secret[0].id
  secret_string = jsonencode({
    username = var.mq_admin_user
  })
}

# Secrets Manager for Admin Password
resource "aws_secretsmanager_secret" "mq_master_password_secret" {
  count       = var.use_secrets_manager && var.mq_admin_password != "" ? 1 : 0
  name        = "${var.secret_manager_key_prefix}/admin/password"
  description = "MQ Admin Password"
  tags        = var.tags
}

resource "aws_secretsmanager_secret_version" "mq_master_password_version" {
  count     = var.use_secrets_manager && var.mq_admin_password != "" ? 1 : 0
  secret_id = aws_secretsmanager_secret.mq_master_password_secret[0].id
  secret_string = jsonencode({
    password = var.mq_admin_password
  })
}

# Secrets Manager for Application User
resource "aws_secretsmanager_secret" "mq_application_username_secret" {
  count       = var.use_secrets_manager && var.mq_application_user != "" ? 1 : 0
  name        = "${var.secret_manager_key_prefix}/application/username"
  description = "AMQ Application Username"
  tags        = var.tags
}

resource "aws_secretsmanager_secret_version" "mq_application_username_version" {
  count     = var.use_secrets_manager && var.mq_application_user != "" ? 1 : 0
  secret_id = aws_secretsmanager_secret.mq_application_username_secret[0].id
  secret_string = jsonencode({
    username = var.mq_application_user
  })
}

# Secrets Manager for Application Password
resource "aws_secretsmanager_secret" "mq_application_password_secret" {
  count       = var.use_secrets_manager && var.mq_application_password != "" ? 1 : 0
  name        = "${var.secret_manager_key_prefix}/application/password"
  description = "AMQ Application Password"
  tags        = var.tags
}

resource "aws_secretsmanager_secret_version" "mq_application_password_version" {
  count     = var.use_secrets_manager && var.mq_application_password != "" ? 1 : 0
  secret_id = aws_secretsmanager_secret.mq_application_password_secret[0].id
  secret_string = jsonencode({
    password = var.mq_application_password
  })
}

# Fallback to SSM if not using Secrets Manager
resource "aws_ssm_parameter" "mq_master_username_ssm" {
  count = var.mq_admin_user != "" && !var.use_secrets_manager ? 1 : 0
  name        = format("%s%s",
    replace(trimspace(var.ssm_path), "/$", ""),
    var.mq_admin_user_ssm_parameter_name
  )
  value       = var.mq_admin_user != "" ? var.mq_admin_user : "default_admin_user"
  description = "MQ Username for the admin user"
  type        = "String"
  tags        = var.tags
  overwrite   = true
  lifecycle {
    prevent_destroy       = false
    create_before_destroy = true
    ignore_changes        = [value]
  }
  depends_on = [aws_ssm_parameter.mq_application_username_ssm]
}

resource "aws_ssm_parameter" "mq_master_password_ssm" {
  count = var.mq_admin_password != "" && !var.use_secrets_manager ? 1 : 0
  name        = "kms-alias"
  value       = var.mq_admin_password != "" ? var.mq_admin_password : "default_password"
  description = "MQ Password for the admin user"
  type        = "SecureString"
  key_id      = module.kms.key_id
  tags        = var.tags
  overwrite   = true
  lifecycle {
    prevent_destroy       = false
    create_before_destroy = true
    ignore_changes        = [value]
  }
  depends_on = [aws_ssm_parameter.mq_application_username_ssm]
}

resource "aws_ssm_parameter" "mq_application_username_ssm" {
  count = var.mq_application_user != "" && !var.use_secrets_manager ? 1 : 0
  name = format("%s%s",
    replace(coalesce(var.ssm_path, ""), "/$", ""),
    var.mq_application_user_ssm_parameter_name
  )
  value       = var.mq_application_user != "" ? var.mq_application_user : "default_application_user"
  description = "AMQ Username for the application user"
  type        = "String"
  tags        = var.tags
  overwrite   = true
  lifecycle {
    prevent_destroy       = false
    create_before_destroy = true
    ignore_changes        = [value]
  }
  depends_on = [aws_ssm_parameter.mq_application_username_ssm]
}

resource "aws_ssm_parameter" "mq_application_password_ssm" {
  count = var.mq_application_password != "" && !var.use_secrets_manager ? 1 : 0
  name = format("%s%s",
    replace(coalesce(var.ssm_path, ""), "/$", ""),
    var.mq_application_password_ssm_parameter_name
  )
  value       = var.mq_application_password != "" ? var.mq_application_password : "default_app_password"
  description = "AMQ Password for the application user"
  type        = "SecureString"
  key_id      = module.kms.key_id
  tags        = var.tags
  overwrite   = true
  lifecycle {
    prevent_destroy       = false
    create_before_destroy = true
    ignore_changes        = [value]
  }
  depends_on = [aws_ssm_parameter.mq_application_username_ssm]
}

# Create CloudWatch Log Group for MQ Logs (if enabled)
resource "aws_cloudwatch_log_group" "mq_logs" {
  count             = var.enable_cloudwatch_logs ? 1 : 0
  name              = "/aws/mq/${var.mq_broker_name}"
  retention_in_days = var.cloudwatch_log_retention_days
  tags              = var.tags
}

# MQ Broker resource
resource "aws_mq_broker" "default" {
  count                      = var.mq_broker_name != "" ? 1 : 0
  broker_name                = var.mq_broker_name
  deployment_mode            = var.deployment_mode
  engine_type                = var.engine_type
  engine_version             = var.engine_version
  host_instance_type         = var.host_instance_type
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  apply_immediately          = var.apply_immediately
  publicly_accessible        = var.publicly_accessible
  subnet_ids                 = var.subnet_ids
  tags                       = var.tags
  security_groups            = var.security_group_id

  # Encryption options - Use AWS-owned KMS key or a custom key
  dynamic "encryption_options" {
    for_each = var.encryption_enabled ? ["true"] : []
    content {
      kms_key_id        = module.kms.key_id
      use_aws_owned_key = false
    }
  }

  # Enable CloudWatch logs for general and audit logs if CloudWatch is enabled
  logs {
    general = var.general_log_enabled ? true : false
    audit   = var.audit_log_enabled ? true : false
  }

  maintenance_window_start_time {
    day_of_week = var.maintenance_day_of_week
    time_of_day = var.maintenance_time_of_day
    time_zone   = var.maintenance_time_zone
  }

  # Dynamically assign the user based on whether admin or application user exists
  dynamic "user" {
    for_each = length(var.mq_admin_user) > 0 || length(var.mq_application_user) > 0 ? [1] : []

    content {
      username = length(var.mq_admin_user) > 0 ? (
        var.use_secrets_manager ? (
          length(aws_secretsmanager_secret.mq_master_username_secret) > 0 ? jsondecode(aws_secretsmanager_secret_version.mq_master_username_version[0].secret_string).username : "default_admin_user"
        ) : var.mq_admin_user
      ) : (
        var.use_secrets_manager ? (
          length(aws_secretsmanager_secret.mq_application_username_secret) > 0 ? jsondecode(aws_secretsmanager_secret_version.mq_application_username_version[0].secret_string).username : "default_application_user"
        ) : var.mq_application_user
      )

      password = length(var.mq_admin_password) > 0 ? (
        var.use_secrets_manager ? (
          length(aws_secretsmanager_secret.mq_master_password_secret) > 0 ? jsondecode(aws_secretsmanager_secret_version.mq_master_password_version[0].secret_string).password : "Admin12345678!"
        ) : var.mq_admin_password
      ) : (
        var.use_secrets_manager ? (
          length(aws_secretsmanager_secret.mq_application_password_secret) > 0 ? jsondecode(aws_secretsmanager_secret_version.mq_application_password_version[0].secret_string).password : "App12345678!"
        ) : var.mq_application_password
      )

      groups         = var.mq_admin_groups
      console_access = var.console_access
    }
  }

  lifecycle {
    prevent_destroy       = false
    create_before_destroy = true
  }

  depends_on = [
    aws_ssm_parameter.mq_application_username_ssm,
    aws_ssm_parameter.mq_master_username_ssm
  ]
}
