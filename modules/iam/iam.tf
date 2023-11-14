
resource "aws_iam_role" "CodePipelineRole" {
  description = "CodePipeline Service Role - ${var.general_description}"
  tags        = var.common_tags
  name        = "CodePipeline_SSO_Permission_Sets_Provision_Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = {
        Service = ["codepipeline.amazonaws.com", "codebuild.amazonaws.com"]
      },
      Action = "sts:AssumeRole"
    }]
  })

  inline_policy {
    name = "CodePipelinePolicy"
    policy = jsonencode({
      Version = "2012-10-17",
      Statement = [
        {
          Effect = "Allow",
          Action = [
            "iam:PassRole"
          ],
          Resource = [
            "*"
          ]
        },
        {
          Effect = "Allow",
          Action = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ],
          Resource = [
#            "arn:aws:logs:us-east-2:${var.account_id}:log-group:/aws/codebuild/CodePipelineRole",
#            "arn:aws:logs:us-east-2:${var.account_id}:log-group:/aws/codebuild/CodePipelineRole:*",
            "*"
          ]
        },
        {
          Effect = "Allow",
          Action = [
#            "s3:PutObject",
#            "s3:GetObject",
#            "s3:GetObjectVersion",
#            "s3:GetBucketAcl",
#            "s3:GetBucketLocation",
            "s3:*"
          ],
          Resource = [
            "*"
#            var.bucket_artifact_arn
#            "arn:aws:s3:::*/"
#            "arn:aws:s3:::<BucketName>*",
#            "arn:aws:s3:::<BucketName>-*/*"
          ]
        },
        {
          Effect   = "Allow",
          Action   = [
            "ecr:*"
          ],
          Resource = "*"
        },
        {
          Effect = "Allow",
          Action = [
            "ecs:DescribeServices",
            "ecs:UpdateService"
          ],
          Resource = "*"
        },
        {
          Effect = "Allow",
          Action = [
            "codebuild:StartBuild",
            "codebuild:StopBuild",
            "codebuild:BatchGetBuilds",
            "codebuild:CreateReportGroup",
            "codebuild:CreateReport",
            "codebuild:UpdateReport",
            "codebuild:BatchPutTestCases",
            "codebuild:BatchPutCodeCoverages"
          ],
          Resource = [
#            var.codebuild_arn
            "*"
#            "arn:aws:codebuild:us-east-1:${var.account_id}:report-group/CodePipelineRole-*"
          ]
        },
#        {
#          Effect = "Allow",
#          Action = "codebuild:*",
#          Resource = "*"
#        }
      ]
    })
  }
}

resource "aws_iam_role" "CodeBuildRole" {
  name = "CodeBuildRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = {
        Service = ["codebuild.amazonaws.com"]
      },
      Action = "sts:AssumeRole"
    }]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AWSCodeBuildAdminAccess"
  ]

  inline_policy {
    name = "CodeBuildPolicy"
    policy = jsonencode({
      Version = "2012-10-17",
      Statement = [
        {
          Effect = "Allow",
          Action = [
            "iam:*"
          ],
          Resource = [
           "*"
          ]
        },
        {
          Effect = "Allow",
          Action = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ],
          Resource = [
#            "arn:aws:logs:us-east-1:${var.account_id}:log-group:/aws/codebuild/CodeBuildRole",
#            "arn:aws:logs:us-east-1:${var.account_id}:log-group:/aws/codebuild/CodeBuildRole:*",
            "*"
          ]
        },
        {
          Effect = "Allow",
          Action = [
            "s3:PutObject",
            "s3:GetObject",
            "s3:GetObjectVersion",
            "s3:GetBucketAcl",
            "s3:GetBucketLocation"
          ],
          Resource = [
#            "arn:aws:s3:::*/",
            var.bucket_artifact_arn
          ]
        },
        {
          Effect   = "Allow",
          Action   = [
            "ecr:*",
            #"ecr:GetAuthorizationToken"
          ],
          Resource = "*"
        },
        {
          Effect = "Allow",
          Action = [
            "codebuild:StartBuild",
            "codebuild:StopBuild",
            "codebuild:BatchGetBuilds",
            "codebuild:CreateReportGroup",
            "codebuild:CreateReport",
            "codebuild:UpdateReport",
            "codebuild:BatchPutTestCases",
            "codebuild:BatchPutCodeCoverages"
          ],
          Resource = [
#            "arn:aws:codebuild:us-east-2:${var.account_id}:report-group/CodeBuildRole-*"
            "*"
          ]
        },
        {
          Effect = "Allow",
          Action = "codebuild:*",
          Resource = "*"
        },
        {
          Effect = "Allow",
          Action = [
            "ecs:DescribeServices",
            "ecs:UpdateService"
          ],
          Resource = "*"
        }
      ]
    })
  }
}

resource "aws_iam_policy" "codestar" {
  #  count  = local.codestar_enabled ? 1 : 0
  name   = "codestar_policy"
  policy = data.aws_iam_policy_document.codestar.json
  #  policy = join("", data.aws_iam_policy_document.codestar.*.json)
}


data "aws_iam_policy_document" "codestar" {
#  count = local.codestar_enabled ? 1 : 0
  statement {
    sid = ""

    actions = [
      "codestar-connections:UseConnection"
    ]

    condition {
      test     = "ForAllValues:StringEquals"
      variable = "codestar-connections:FullRepositoryId"
      values = [
        format("%s/%s", var.GitHubOwner, var.GitHubRepo)
      ]
    }

    resources = [var.codestar_connection_arn]
    effect    = "Allow"

  }
}

resource "aws_iam_role_policy_attachment" "codestar" {
  #  count      = local.codestar_enabled ? 1 : 0
  role       = aws_iam_role.CodePipelineRole.id
  policy_arn = aws_iam_policy.codestar.arn
  #  role       = join("", aws_iam_role.default.*.id)
  #  policy_arn = join("", aws_iam_policy.codestar.*.arn)
}

#module "codestar_label" {
#  source     = "cloudposse/label/null"
#  version    = "0.25.0"
#  enabled    = local.codestar_enabled
#  attributes = ["codestar"]
#
#  context = module.this.context
#}

resource "aws_iam_role" "notificationRuleRole" {
  name = "snsNotificationRuleRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = {
        Service = "events.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })

  inline_policy {
    name = "sample-notification-rule-role-policy"
    policy = jsonencode({
      Version = "2012-10-17",
      Statement = [
        {
          Effect = "Allow",
          Action = "sns:Publish",
          Resource = "*"
        }
      ]
    })
  }
}

#======ECS Task Role=========
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "ecs_task_execution_policy" {
  name = "ecsTaskExecutionPolicy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetRepositoryPolicy",
          "ecr:DescribeRepositories",
          "ecr:ListImages",
          "ecr:DescribeImages",
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
          # Add more permissions as needed for your use case
        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_attachment" {
  policy_arn = aws_iam_policy.ecs_task_execution_policy.arn
  role       = aws_iam_role.ecs_task_execution_role.name
}

#resource "aws_ecr_repository_policy" "my_repository_policy" {
#  repository = var.ecr_repository_name
#  policy     = data.aws_iam_policy_document.ecr_repository_policy.json
#}
#
#data "aws_iam_policy_document" "ecr_repository_policy" {
#  statement {
#    sid = "ECRAllow*"
#
#    effect = "Allow"
#
#    actions = [
#      "ecr:BatchCheckLayerAvailability",
#      "ecr:BatchGetImage",
#      "ecr:CompleteLayerUpload",
#      "ecr:DescribeImages",
#      "ecr:DescribeRepositories",
#      "ecr:GetDownloadUrlForLayer",
#      "ecr:InitiateLayerUpload",
#      "ecr:PutImage",
#      "ecr:UploadLayerPart"
#    ]
#
#    principals {
#      identifiers = [var.account_id]
#      type        = "AWS"
#    }
#  }
#}
#=======================END IAM==========================
