
# ------------------------------------------------------------------------------
# Versions
# ------------------------------------------------------------------------------
terraform {
  required_version = ">= 1.4.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.1.0"
}
  }
}
terraform {
  required_version = ">= 1.6.6"

  required_providers {

    aws = {
      source  = "hashicorp/aws"#
      version = ">= 5.31.0"
    }
    }
  }

