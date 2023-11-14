data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
  region = "us-east-2"

  #=====common-tags============
  common_tags = {
    Project   = "My CI-CD Project"
    ManagedBy = "Terraform"
  }
  general_description = "ci-cd"
  env                 = "dev"

  #=====SNS======
  NotificationEmail = "djemmy1987@gmail.com"

  #=====Codepipeline======
  GitHubBranch     = "main"
  GitHubOAuthToken = "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"
  GitHubOwner      = "trextozyne"
  GitHubRepo       = "aws_ci_cd-python_app"

  #=====CodeStar======
  codestar_name    = "GitHub_Codestar_Connection"
  provider_type    = "GitHub"
  codestar_tags    = { Name = "GitHub_Codestar_Connection" }

  #===========VPC=====================
  vpc_region = ["us-east-2"]
  vpc_cidr = "18.0.0.0/16"
  main_vpc_cidr = "18.0.0.0/16"
  public_subnets = ["18.0.0.0/24", "18.0.2.0/24"]
  public_subnets_2 = "18.0.2.0/24"
  private_subnets  = ["18.0.1.0/24", "18.0.3.0/24"]
  private_subnets_2  = "18.0.3.0/24"
  subnet_cidr_bits  = 8
  availability_zones_count  = 2
  project  = "trex-dev-"
#  PrivateSubnet1CIDR = "18.0.1.0/24"
#  PrivateSubnet2CIDR = "18.0.3.0/24"
#  PublicSubnet1CIDR  = "18.0.0.0/24"
#  PublicSubnet2CIDR  = "18.0.2.0/24"

  #=====code-build======
  github_location = "https://github.com/${local.GitHubOwner}/${local.GitHubRepo}.git"

  codebuild_configuration = {
    cb_compute_type = "BUILD_GENERAL1_SMALL"
    cb_image        = "aws/codebuild/amazonlinux2-x86_64-standard:4.0" #5.0
    cb_type         = "LINUX_CONTAINER"
  }

  #=====ECS======
  image_name         = "ecs-flaskapp"
  ecs_app_name       = "flaskapp"
  ecs_image_location = "${local.account_id}.dkr.ecr.${local.region}.amazonaws.com/${local.image_name}:latest"
  ecs_portMappings = [
    {
      name          = "flaskapp-80-tcp"
      containerPort = 80
      hostPort      = 80
      protocol      = "tcp"
      appProtocol   = "http"
    }
  ]

  ecs_service_name                   = "ECS-Service"
  service_discovery_private_dns_name = "aws-the-rexy.click"
  ecs_service_launch_type            = "FARGATE"

  ecs_service_discovery           = "ecs_discover"
  ecs_service_scheduling_strategy = "REPLICA"
  ecs_service_desired_count       = 2
  ecs_service_load_balancer = {
    container_name = "flaskapp"
    container_port = 80
  }

  ecs_service_service_registries = {
    container_name = "flaskapp_service_registry"
    container_port = 80
    port = 80
  }
  ecs_service_deployment_minimum_healthy_percent = 100
  ecs_service_deployment_maximum_percent         = 200

  #=============s3================
  codebuild_artifact_bucket = "${local.env}-ecs-ci-cd-${local.account_id}"

}







