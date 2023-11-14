variable "availability_zones_count" {
  default = ""
}
module "vpc" {
  source             = "../../modules/vpc"
  env                      = local.env
  project                  = local.project
  main_vpc_cidr            = local.main_vpc_cidr
  public_subnets           = local.public_subnets
  private_subnets          = local.private_subnets
  vpc_cidr                 = local.vpc_cidr
  subnet_cidr_bits         = local.subnet_cidr_bits
  availability_zones_count = local.availability_zones_count
  vpc_id                   = module.vpc.vpc_ids
}

module "security-group" {
  source = "../../modules/security-group"
  vpc_id = module.vpc.vpc_ids #.vpc_id
}

module "alb" {
  source           = "../../modules/alb"
  public_subnet_1 = module.vpc.subnet_public[0]
  public_subnet_2 = module.vpc.subnet_public[1]
  alb_sg_id            = module.security-group.alb_sg_id
  vpc_id           = module.vpc.vpc_ids
}

module "ecs" {
  source                                         = "../../modules/ecs"
  alb_target_group_arn                           = module.alb.alb_target_group_arn
  ecs_app_name                                   = local.ecs_app_name
  image_name                                     = local.image_name
  ecs_image_location                             = local.ecs_image_location
  ecs_portMappings                               = local.ecs_portMappings
  ecs_service_deployment_maximum_percent         = local.ecs_service_deployment_maximum_percent
  ecs_service_deployment_minimum_healthy_percent = local.ecs_service_deployment_minimum_healthy_percent
  ecs_service_desired_count                      = local.ecs_service_desired_count
  ecs_service_discovery                          = local.ecs_service_discovery
  ecs_service_launch_type                        = local.ecs_service_launch_type
  ecs_service_load_balancer                      = local.ecs_service_load_balancer
  ecs_service_name                               = local.ecs_service_name
  ecs_service_scheduling_strategy                = local.ecs_service_scheduling_strategy
  private_subnet_1                               = module.vpc.subnet_private[0]
  private_subnet_2                               = module.vpc.subnet_private[1]
  service_discovery_private_dns_name             = local.service_discovery_private_dns_name
  ecs_service_service_registries = local.ecs_service_service_registries
  sg_id                                          = module.security-group.sg_id
  vpc_id                                         = module.vpc.vpc_ids

  account_id = local.account_id
  ecs_task_execution_iam_role_arn = module.iam.ecs_task_execution_iam_role_arn
  cloudwatch_loggroup_id = module.cloudwatch.cloudwatch_loggroup_id
  env = local.env
  region = local.region
}

module "iam" {
  source              = "../../modules/iam"
  account_id          = local.account_id
  bucket_artifact_arn = module.s3.bucket_artifact_arn
  codebuild_arn       = module.codebuild.codebuild_arn
  common_tags         = local.common_tags
  general_description = local.general_description
  GitHubOwner         = local.GitHubOwner
  GitHubRepo          = local.GitHubRepo
  codestar_connection_arn = module.codestar.codestar_connection_arn
  ecr_repository_name = module.ecs.ecr_repository_name
}

module "codestar" {
  source = "../../modules/codestar"
  name   = local.codestar_name
  provider_type = local.provider_type
  tags = local.codestar_tags
}

module "codepipeline" {
  source                    = "../../modules/codepipeline"
  GitHubBranch              = local.GitHubBranch
  GitHubOAuthToken          = local.GitHubOAuthToken
  GitHubOwner               = local.GitHubOwner
  GitHubRepo                = local.GitHubRepo
  bucket_artifact_id        = module.s3.bucket_artifact_id
  codebuild_project_name    = module.codebuild.codebuild_project_name
  codepipeline_iam_role_arn = module.iam.codepipeline_iam_role_arn
  env                       = local.env
  codestar_connection_arn   = module.codestar.codestar_connection_arn
}

module "codebuild" {
  source                  = "../../modules/codebuild"
  codebuild_configuration = local.codebuild_configuration
  codebuild_iam_role_arn  = module.iam.codepipeline_iam_role_arn
  github_location         = local.github_location
  account_id              = local.account_id
  image_name              = local.image_name
}

module "sns" {
  source            = "../../modules/sns"
  NotificationEmail = local.NotificationEmail
}

module "s3" {
  source           = "../../modules/s3"
  codebuild_bucket = local.codebuild_artifact_bucket
  common_tags      = local.common_tags
}

module "cloudwatch" {
  source                         = "../../modules/cloudwatch"
  codebuild_project_name         = module.codebuild.codebuild_project_name
  codebuild_sns_topic_arn        = module.sns.codebuild_sns_topic_arn
  sns_notification_rule_iam_role = module.iam.sns_notification_rule_iam_role
  ecs_app_name                   = local.ecs_app_name
  env                            = local.env
}

