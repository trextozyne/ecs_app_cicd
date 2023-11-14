
resource "aws_codebuild_project" "CodeBuildProject" {
  name       = "CodeBuildProject"
  service_role = var.codebuild_iam_role_arn

  source {
    type = "GITHUB"
    location = var.github_location
    buildspec = "buildspec.yml"
  }

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type    = var.codebuild_configuration["cb_compute_type"]
    image           = var.codebuild_configuration["cb_image"]
    type            = var.codebuild_configuration["cb_type"]
    privileged_mode = true

    environment_variable {
      name  = "account_id"
      value = var.account_id
    }

    environment_variable {
      name  = "IMAGE_REPO_NAME"
      value = var.image_name
    }
  }
}
#dynamic "environment_variable" {
#  for_each = var.env_vars
#  content {
#    name  = environment_variable.key
#    value = environment_variable.value
#  }
#}

#variable "env_vars" {
#  default = {
#    SOME_KEY1 = "SOME_VALUE1"
#    SOME_KEY2 = "SOME_VALUE2"
#  }
#}

#===========================END CODEBUILD=========================
