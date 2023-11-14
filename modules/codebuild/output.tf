output "codebuild_project_name" {
  value = aws_codebuild_project.CodeBuildProject.name
}

output "codebuild_arn" {
  value = aws_codebuild_project.CodeBuildProject.arn
}