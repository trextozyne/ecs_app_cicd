
resource "aws_codepipeline_webhook" "GithubWebhook" {
  authentication = "GITHUB_HMAC"
  name = "${var.env}-codepipeline_webhook_github"

  authentication_configuration {
    secret_token = var.GitHubOAuthToken
  }

#  register_with_third_party = true

  target_action = aws_codepipeline.CodePipeline.stage[0].action[0].name
  target_pipeline = aws_codepipeline.CodePipeline.name
  #  target_pipeline_version = aws_codepipeline.CodePipeline.stage[0].action[0].configuration[0].output_artifacts[0].store[0].encryption_key_id


  filter {
    json_path = "$.ref"
    match_equals = "refs/heads/${var.GitHubBranch}"
  }
}

resource "aws_codepipeline" "CodePipeline" {
  name     = "${var.env}-ECS-Pipeline"
  role_arn = var.codepipeline_iam_role_arn

#  restart_execution_on_update = true

  artifact_store {
    type     = "S3"
    location = var.bucket_artifact_id
  }


  stage {
    name = "Clone"

    action {
      name = "Source"
      category = "Source"
#      owner    = "ThirdParty"
#      provider = "GitHub"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version  = "1"
      output_artifacts = ["SourceCode"]

      configuration = {
        BranchName           = var.GitHubBranch
        FullRepositoryId     = format("%s/%s", var.GitHubOwner, var.GitHubRepo)
        ConnectionArn        = var.codestar_connection_arn
        OutputArtifactFormat = "CODE_ZIP"
      }
#      configuration = {
#        Owner              = var.GitHubOwner
#        RepositoryName              = var.GitHubRepo
#        BranchName             = var.GitHubBranch
#        PollForSourceChanges = true
#        OAuthToken        = var.GitHubOAuthToken
#      }

      run_order = 1
    }
  }

  stage {
    name = "Build"

    action {
      name = "BuildAction"
      category = "Build"
      owner    = "AWS"
      version  = "1"
      provider = "CodeBuild"

      input_artifacts = ["SourceCode"]
      output_artifacts = ["BuildOutput"]

      configuration = {
        ProjectName = var.codebuild_project_name
      }

      run_order = 2
    }
  }

#  stage {
#    ...
#  }
}
#===============================END CODEPIPELINE==============================
#stage {
#  name = "Manual-Approval"
#
#  action {
#    run_order = 1
#    name             = "AWS-Admin-Approval"
#    category         = "Approval"
#    owner            = "AWS"
#    provider         = "Manual"
#    version          = "1"
#    input_artifacts  = []
#    output_artifacts = []
#
#    configuration = {
#      CustomData = "Please verify the terraform plan output on the Plan stage and only approve this step if you see expected changes!"
#    }
#  }
#}
#
#stage {
#  name = "Deploy"
#
#  action {
#    run_order        = 1
#    name             = "Terraform-Apply"
#    category         = "Build"
#    owner            = "AWS"
#    provider         = "CodeBuild"
#    input_artifacts  = ["CodeWorkspace", "TerraformPlanFile"]
#    output_artifacts = []
#    version          = "1"
#
#    configuration = {
#      ProjectName          = var.codebuild_tfapply_name
#      PrimarySource        = "CodeWorkspace"
#      EnvironmentVariables = jsonencode([
#        {
#          name  = "PIPELINE_EXECUTION_ID"
#          value = "#{codepipeline.PipelineExecutionId}"
#          type  = "PLAINTEXT"
#        }
#      ])
#    }
#  }
#}
#}