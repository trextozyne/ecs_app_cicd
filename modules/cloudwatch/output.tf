output "cloudwatch_loggroup_id" {
  value = aws_cloudwatch_log_group.ecs_log_group.id
}