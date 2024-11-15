locals {
  enabled = var.enabled  # Directly use the variable 'enabled'

  # Admin user enabled if the engine type is ActiveMQ and no user is provided
  mq_admin_user_enabled  = local.enabled && var.engine_type == "ActiveMQ"
  mq_admin_user_needed   = local.mq_admin_user_enabled && length(var.mq_admin_user) == 0
  mq_admin_user          = local.mq_admin_user_needed ? "" : try(var.mq_admin_user, "")

  mq_admin_password_needed  = local.mq_admin_user_enabled && length(var.mq_admin_password) == 0
  mq_admin_password         = local.mq_admin_password_needed ? "" : try(var.mq_admin_password, "")

  # Logs configuration
  mq_logs = {
    logs = {
      "general_log_enabled" : var.general_log_enabled,
      "audit_log_enabled"   : var.audit_log_enabled
    }
  }

  # Ensure var.security_group_id is always a list (even if it contains one element)
  # security_group_ids = type(var.security_group_id) == "list" ? var.security_group_id : [var.security_group_id]

  # Combine the security group ID provided and additional security group IDs
  # broker_security_groups = compact(concat(security_group_ids, local.additional_security_group_ids))
}

resource "aws_mq_broker" "default" {
  count                      = var.enabled ? 1 : 0
  broker_name                = var.broker_name
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
  # Ensure security_groups is always a valid list with at least one group
  # security_groups = length(local.broker_security_groups) > 0 ? local.broker_security_groups : ["default-security-group-id"]

  # Encryption options, enabled if the flag is true
  dynamic "encryption_options" {
    for_each = var.encryption_enabled ? [1] : []
    content {
      kms_key_id        = var.kms_mq_key_arn
      use_aws_owned_key = var.use_aws_owned_key
    }
  }

  # Logs block: Use direct booleans for logging configuration
  logs {
    general = var.general_log_enabled
    audit   = var.audit_log_enabled
  }

  # Maintenance window configuration
  maintenance_window_start_time {
    day_of_week = var.maintenance_day_of_week
    time_of_day = var.maintenance_time_of_day
    time_zone   = var.maintenance_time_zone
  }

  # Ensure at least one user block is always present
  user {
    username       = var.mq_admin_user != "" ? var.mq_admin_user : "default_admin"  # Fallback to "default_admin"
    password       = var.mq_admin_password != "" ? var.mq_admin_password : "default_password"  # Fallback to "default_password"
    groups         = ["admin"]
    console_access = true
  }
}
