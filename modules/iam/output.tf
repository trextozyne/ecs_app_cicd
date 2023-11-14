
output "sns_notification_rule_iam_role" {
  value = aws_iam_role.notificationRuleRole.arn
}

output "codebuild_iam_role_arn" {
  value = aws_iam_role.CodeBuildRole.arn
}

output "codepipeline_iam_role_arn" {
  value = aws_iam_role.CodePipelineRole.arn
}

output "ecs_task_execution_iam_role_arn" {
  value = aws_iam_role.ecs_task_execution_role.arn
}