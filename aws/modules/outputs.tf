output "roleA_arn" {
  description = "The ARN of roleA."
  value       = aws_iam_role.roleA.arn
}

output "roleA_id" {
  description = "The ID of roleA."
  value       = aws_iam_role.roleA.id
}

output "roleA_name" {
  description = "The name of roleA."
  value       = aws_iam_role.roleA.name
}

output "roleB_arn" {
  description = "The ARN of roleB."
  value       = aws_iam_role.roleB.arn
}

output "roleB_id" {
  description = "The ID of roleB."
  value       = aws_iam_role.roleB.id
}

output "roleB_name" {
  description = "The name of roleB."
  value       = aws_iam_role.roleB.name
}

output "roleC_arn" {
  description = "The ARN of roleC in the other AWS account."
  value       = aws_iam_role.roleC.arn
}

output "roleC_id" {
  description = "The ID of roleC in the other AWS account."
  value       = aws_iam_role.roleC.id
}

output "roleC_name" {
  description = "The name of roleC in the other AWS account."
  value       = aws_iam_role.roleC.name
}

output "roleA_policy_id" {
  description = "The ID of the policy attached to roleA."
  value       = aws_iam_role_policy.roleA_policy.id
}

output "roleB_policy_id" {
  description = "The ID of the policy attached to roleB."
  value       = aws_iam_role_policy.roleB_policy.id
}

output "roleC_policy_id" {
  description = "The ID of the policy attached to roleC in the other AWS account."
  value       = aws_iam_role_policy.roleC_policy.id
}
