// IAM outputs
output "power_user_role" {
  value = data.aws_iam_role.power_user
}
output "power_policy" {
  value = data.aws_iam_policy.power
}
output "github_oidc_provider" {
  value = local.github_oidc_arn != null ? data.aws_iam_openid_connect_provider.github_actions[0] : null
}

// Integration token outputs
output "github_token" {
  value = local.github_token
}
