

output "ECSServiceName" {
  description = "ECS service name"
  value       = aws_ecs_service.ECSService.name
}

output "ecr_repository_name" {
  description = "ECR Repository Name"
  value       = aws_ecr_repository.MyECRRepository.name
}