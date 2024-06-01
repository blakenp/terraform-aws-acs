terraform {
  required_version = ">= 1.8.4"
  required_providers {
    aws = ">= 5.51.1"
  }
}

data "aws_iam_account_alias" "current" {
  count = 0 // Do not fetch account alias if not needed
}

data "aws_iam_account_alias" "current" {}

data "aws_ssm_parameter" "acs_parameters" {
  name = "acsParameters"
}

locals {
  acs_info = jsondecode(data.aws_ssm_parameter.acs_parameters.value)

  github_oidc_arn              = lookup(local.acs_info, "/acs/git/oidc-arn", null)
  github_token                 = lookup(local.acs_info, "/acs/git/token", null)
}

// IAM info
data "aws_iam_role" "power_user" {
  name = "PowerUser"
}
data "aws_iam_role" "read_only" {
  name = "AccountReadOnlyUser"
}
data "aws_iam_policy" "power" {
  name = "PowerPolicy"
}
data "aws_iam_openid_connect_provider" "github_actions" {
  count = local.github_oidc_arn != null ? 1 : 0
  arn   = local.github_oidc_arn
}
