#variable "VpcCIDR" {
#  description = "CIDR block for the VPC"
#  type        = string
#  default     = "18.0.0.0/16"
#}
#
#variable "PublicSubnet1CIDR" {
#  description = "CIDR block for the First public subnet"
#  type        = string
#  default     = "18.0.0.0/24"
#}
#
#variable "PrivateSubnet1CIDR" {
#  description = "CIDR block for the First private subnet"
#  type        = string
#  default     = "18.0.1.0/24"
#}
#
#variable "PublicSubnet2CIDR" {
#  description = "CIDR block for the Second public subnet"
#  type        = string
#  default     = "18.0.2.0/24"
#}
#
#variable "PrivateSubnet2CIDR" {
#  description = "CIDR block for the Second private subnet"
#  type        = string
#  default     = "18.0.3.0/24"
#}
#
#variable "GitHubOwner" {
#  description = "Name of GitHub Owner"
#  type        = string
#  default     = ""
#}
#
#variable "GitHubRepo" {
#  description = "Name of GitHub Repo"
#  type        = string
#  default     = ""
#}
#
#variable "GitHubBranch" {
#  description = "Name of GitHub Repo Branch"
#  type        = string
#  default     = ""
#}
#
#variable "GitHubOAuthToken" {
#  description = "GitHub OAuth Token"
#  type        = string
#  default     = ""
#}
#
#variable "BuckerName" {
#  description = "S3 Bucket Name"
#  type        = string
#  default     = ""
#}
#
#variable "NotificationEmail" {
#  description = "Email address where notifications will be sent"
#  type        = string
#  default     = ""
#}
#
##=====================================END VARIABLES==========================
#resource "aws_vpc" "PrivateVPC" {
#  cidr_block = var.VpcCIDR
#  tags = {
#    "Name" = "PrivateVPC"
#  }
#}
#
#resource "aws_internet_gateway" "InternetGateway" {
#  vpc_id = aws_vpc.PrivateVPC.id
#  tags = {
#    "Name" = "InternetGateway"
#  }
#}
#
#resource "aws_vpc" "PrivateVPC" {
#  cidr_block = var.VpcCIDR
#  tags = {
#    "Name" = "PrivateVPC"
#  }
#}
#
#resource "aws_internet_gateway" "InternetGateway" {
#  vpc_id = aws_vpc.PrivateVPC.id
#  tags = {
#    "Name" = "InternetGateway"
#  }
#}
#
#resource "aws_vpc_attachment" "VPCGatewayAttachment" {
#  vpc_id             = aws_vpc.PrivateVPC.id
#  internet_gateway_id = aws_internet_gateway.InternetGateway.id
#}
#
#resource "aws_subnet" "PublicSubnet1" {
#  vpc_id                  = aws_vpc.PrivateVPC.id
#  cidr_block              = var.PublicSubnet1CIDR
#  availability_zone       = "us-east-1a"
#  map_public_ip_on_launch = true
#  tags = {
#    "Name" = "PublicSubnet-az-1"
#  }
#}
#
#resource "aws_subnet" "PrivateSubnet1" {
#  vpc_id      = aws_vpc.PrivateVPC.id
#  cidr_block  = var.PrivateSubnet1CIDR
#  availability_zone = "us-east-1a"
#  tags = {
#    "Name" = "PrivateSubnet-az-1"
#  }
#}
#
#resource "aws_subnet" "PublicSubnet2" {
#  vpc_id                  = aws_vpc.PrivateVPC.id
#  cidr_block              = var.PublicSubnet2CIDR
#  availability_zone       = "us-east-1b"
#  map_public_ip_on_launch = true
#  tags = {
#    "Name" = "PublicSubnet-az-2"
#  }
#}
#
#resource "aws_subnet" "PrivateSubnet2" {
#  vpc_id      = aws_vpc.PrivateVPC.id
#  cidr_block  = var.PrivateSubnet2CIDR
#  availability_zone = "us-east-1b"
#  tags = {
#    "Name" = "PrivateSubnet-az-2"
#  }
#}
#
#resource "aws_route_table" "PublicRouteTable1" {
#  vpc_id = aws_vpc.PrivateVPC.id
#}
#
#resource "aws_route_table" "PublicRouteTable2" {
#  vpc_id = aws_vpc.PrivateVPC.id
#}
#
#resource "aws_route" "PublicRoute1" {
#  depends_on            = [aws_vpc_attachment.VPCGatewayAttachment]
#  route_table_id       = aws_route_table.PublicRouteTable1.id
#  destination_cidr_block = "0.0.0.0/0"
#  gateway_id           = aws_internet_gateway.InternetGateway.id
#}
#
#resource "aws_route" "PublicRoute2" {
#  depends_on            = [aws_vpc_attachment.VPCGatewayAttachment]
#  route_table_id       = aws_route_table.PublicRouteTable2.id
#  destination_cidr_block = "0.0.0.0/0"
#  gateway_id           = aws_internet_gateway.InternetGateway.id
#}
#
#resource "aws_subnet_association" "PublicSubnet1RouteTableAssociation" {
#  subnet_id      = aws_subnet.PublicSubnet1.id
#  route_table_id = aws_route_table.PublicRouteTable1.id
#}
#
#resource "aws_subnet_association" "PublicSubnet2RouteTableAssociation" {
#  subnet_id      = aws_subnet.PublicSubnet2.id
#  route_table_id = aws_route_table.PublicRouteTable2.id
#}
#
#resource "aws_eip" "NATGatewayEIP1" {}
#
#resource "aws_nat_gateway" "NATGateway1" {
#  allocation_id = aws_eip.NATGatewayEIP1.id
#  subnet_id     = aws_subnet.PublicSubnet1.id
#}
#
#resource "aws_eip" "NATGatewayEIP2" {}
#
#resource "aws_nat_gateway" "NATGateway2" {
#  allocation_id = aws_eip.NATGatewayEIP2.id
#  subnet_id     = aws_subnet.PublicSubnet2.id
#}
#
#resource "aws_route_table" "PrivateRouteTable1" {
#  vpc_id = aws_vpc.PrivateVPC.id
#  tags = {
#    "Name" = "PrivateRouteTable1"
#  }
#}
#
#resource "aws_route_table" "PrivateRouteTable2" {
#  vpc_id = aws_vpc.PrivateVPC.id
#  tags = {
#    "Name" = "PrivateRouteTable2"
#  }
#}
#
#resource "aws_route" "PrivateRoute1" {
#  depends_on            = [aws_nat_gateway.NATGateway1]
#  route_table_id       = aws_route_table.PrivateRouteTable1.id
#  destination_cidr_block = "0.0.0.0/0"
#  gateway_id           = aws_internet_gateway.InternetGateway.id
#}
#
#resource "aws_route" "PrivateRoute2" {
#  depends_on            = [aws_nat_gateway.NATGateway2]
#  route_table_id       = aws_route_table.PrivateRouteTable2.id
#  destination_cidr_block = "0.0.0.0/0"
#  gateway_id           = aws_internet_gateway.InternetGateway.id
#}
#
#resource "aws_subnet_association" "PrivateSubnet1Association" {
#  subnet_id      = aws_subnet.PrivateSubnet1.id
#  route_table_id = aws_route_table.PrivateRouteTable1.id
#}
#
#resource "aws_subnet_association" "PrivateSubnet2Association" {
#  subnet_id      = aws_subnet.PrivateSubnet2.id
#  route_table_id = aws_route_table.PrivateRouteTable2.id
#}
##=========================================END VPC=======================
#
#resource "aws_ecr_repository" "MyECRRepository" {
#  name = "ecs-flaskapp"
#
#  image_scanning_configuration {
#    scan_on_push = true
#  }
#
#  image_tag_mutability = "MUTABLE"
#}
#
#resource "aws_ecs_cluster" "ECSCluster" {
#  name = "ECS-Cluster-FlaskApp"
#
#  configuration {
#    execute_command_configuration {
#      logging = "DEFAULT"
#    }
#  }
#
#  setting {
#    name  = "containerInsights"
#    value = "enabled"
#  }
#
#  service_connect_defaults {
#    namespace = "ECSClusterNamespace"
#  }
#}
#
#resource "aws_ecs_cluster_capacity_providers" "capacity_providers" {
#  cluster_name = aws_ecs_cluster.ECSCluster.name
#  capacity_providers = ["FARGATE_SPOT", "FARGATE"]
#
#  default_capacity_provider_strategy {
#    capacity_provider = "FARGATE_SPOT"
#  }
#}
#
#resource "aws_ecs_task_definition" "ecs_service" {
#  family                   = "TaskDefinatioECS-Service"
#  network_mode             = "awsvpc"
#  execution_role_arn       = "arn:aws:iam::${var.account_id}:role/ecsTaskExecutionRole"
#  cpu                      = "1024"
#  memory                   = "3072"
#  requires_compatibilities = ["FARGATE"]
#
#  container_definitions = jsonencode([{
#    name  = "flaskapp"
#    image = "${var.account_id}.dkr.ecr.us-east-1.amazonaws.com/ecs-flaskapp:latest"
#    cpu   = 0
#
#    portMappings = [{
#      name          = "flaskapp-80-tcp"
#      containerPort = 80
#      hostPort      = 80
#      protocol      = "tcp"
#      appProtocol   = "http"
#    }]
#
#    essential = true
#
#    environment = [
#      {
#        name  = "NAME"
#        value = "World"
#      }
#    ]
#
#    environmentFiles = []
#    mountPoints      = []
#    volumesFrom      = []
#    limits          = []
#  }])
#
#  status = "ACTIVE"
#
#  requires_attributes = [
#    {
#      name = "com.amazonaws.ecs.capability.ecr-auth"
#    },
#    {
#      name = "ecs.capability.execution-role-ecr-pull"
#    },
#    {
#      name = "com.amazonaws.ecs.capability.docker-remote-api.1.18"
#    },
#    {
#      name = "ecs.capability.task-eni"
#    }
#  ]
#
#  compatibilities = [
#    "EC2",
#    "FARGATE"
#  ]
#
#  runtime_platform {
#    cpuArchitecture       = "X86_64",
#    operatingSystemFamily = "LINUX"
#  }
#}
#
#resource "aws_service_discovery_public_dns_namespace" "ecs_private_dns" {
#  name        = "aws-the-rexy.click"
#  description = "ecs public dns"
#  vpc         = aws_vpc.PrivateVPC.id
#}
#
#resource "aws_service_discovery_service" "ecs_service_discovery" {
#  name = "ecs_discover"
#  dns_config {
#    namespace_id = aws_service_discovery_public_dns_namespace.ecs_private_dns.id
#    dns_records {
#      ttl = 10
#      type = "SRV"
#    }
#    routing_policy = "MULTIVALUE"
#  }
#
#  health_check_custom_config {
#    failure_threshold = 2
#  }
#}
#
#resource "aws_ecs_service" "ECSService" {
#  name            = "ECS-Service"
#  cluster         = aws_ecs_cluster.ECSCluster.id
#  task_definition = aws_ecs_task_definition.ecs_service.family #var.task_definition_path
#  launch_type     = "FARGATE"
#  scheduling_strategy = "REPLICA"
#  desired_count  = 2
#
#  load_balancer {
#    container_name   = "flaskapp"
#    container_port   = 80
#    target_group_arn = aws_lb_target_group.TargetGroup.arn
#  }
#
#  network_configuration {
#      assign_public_ip = "ENABLED"
#      security_groups = [aws_security_group.SecurityGroup.id]
#      subnets = [aws_subnet.PrivateSubnet1.id, aws_subnet.PrivateSubnet2.id]
#  }
#
#  deployment_controller {
#    type = "ECS"
#  }
#
#  platform_version = "LATEST"
#
#  deployment_minimum_healthy_percent = 200
#  deployment_maximum_percent         = 100
#  deployment_circuit_breaker {
#    enable   = true
#    rollback = true
#  }
#
#  service_registries {
#    registry_arn = aws_service_discovery_service.ecs_service_discovery.id
#  }
#
#  enable_ecs_managed_tags = true
#}
##===================================END ECS============================================
#
#resource "aws_security_group" "SecurityGroup" {
#  name        = "ECS-SG"
#  description = "SecurityGroup for ECS"
#  vpc_id      = aws_vpc.PrivateVPC.id
#
#  ingress {
#    from_port   = 80
#    to_port     = 80
#    protocol    = "tcp"
#    cidr_blocks = ["0.0.0.0/0"]
#    ipv6_cidr_blocks = ["::/0"]
#  }
#}
##==============================END SG================================================
#resource "aws_lb" "LoadBalancer" {
#  name               = "ALB-ECS-Service"
#  internal           = false
#  load_balancer_type = "application"
#  security_groups   = [aws_security_group.SecurityGroup.id]
#  subnets = [aws_subnet.PrivateSubnet1.id, aws_subnet.PrivateSubnet2.id]
#}
#
#resource "aws_lb_target_group" "TargetGroup" {
#  name     = "ECS-TG"
#  port     = 80
#  protocol = "HTTP"
#  target_type = "ip"
#  vpc_id   = aws_vpc.PrivateVPC.id
#
#  health_check {
#    path     = "/"
#    protocol = "HTTP"
#  }
#}
#
#resource "aws_lb_listener" "Listener" {
#  load_balancer_arn = aws_lb.LoadBalancer.arn
#  port              = 80
#  protocol          = "HTTP"
#
#  default_action {
#    type             = "forward"
#    target_group_arn = aws_lb_target_group.TargetGroup.arn
#  }
#}
#
##=============================END LOADBALANCER===========================
#
#resource "aws_iam_role" "CodePipelineRole" {
#  name = "CodePipelineRole"
#
#  assume_role_policy = jsonencode({
#    Version = "2012-10-17",
#    Statement = [{
#      Effect    = "Allow",
#      Principal = {
#        Service = ["codepipeline.amazonaws.com", "codebuild.amazonaws.com"]
#      },
#      Action = "sts:AssumeRole"
#    }]
#  })
#
#  policies = [{
#    name = "CodePipelinePolicy",
#    policy = jsonencode({
#      Version = "2012-10-17",
#      Statement = [
#        {
#          Effect = "Allow",
#          Action = [
#            "logs:CreateLogGroup",
#            "logs:CreateLogStream",
#            "logs:PutLogEvents"
#          ],
#          Resource = [
#            "arn:aws:logs:us-east-1:${var.account_id}:log-group:/aws/codebuild/CodePipelineRole",
#            "arn:aws:logs:us-east-1:${var.account_id}:log-group:/aws/codebuild/CodePipelineRole:*",
#            "*"
#          ]
#        },
#        {
#          Effect = "Allow",
#          Action = [
#            "s3:PutObject",
#            "s3:GetObject",
#            "s3:GetObjectVersion",
#            "s3:GetBucketAcl",
#            "s3:GetBucketLocation",
#            "s3:*"
#          ],
#          Resource = [
#            "arn:aws:s3:::<BuckerName>*",
#            "arn:aws:s3:::<BuckerName>-*/*"
#          ]
#        },
#        {
#          Effect = "Allow",
#          Action = "ecr:GetAuthorizationToken",
#          Resource = "*"
#        },
#        {
#          Effect = "Allow",
#          Action = [
#            "codebuild:CreateReportGroup",
#            "codebuild:CreateReport",
#            "codebuild:UpdateReport",
#            "codebuild:BatchPutTestCases",
#            "codebuild:BatchPutCodeCoverages"
#          ],
#          Resource = [
#            "arn:aws:codebuild:us-east-1:${var.account_id}:report-group/CodePipelineRole-*"
#          ]
#        },
#        {
#          Effect = "Allow",
#          Action = "codebuild:*",
#          Resource = "*"
#        }
#      ]
#    })
#  }]
#}
#
#resource "aws_iam_role" "CodeBuildRole" {
#  name = "CodeBuildRole"
#
#  assume_role_policy = jsonencode({
#    Version = "2012-10-17",
#    Statement = [{
#      Effect    = "Allow",
#      Principal = {
#        Service = ["codebuild.amazonaws.com"]
#      },
#      Action = "sts:AssumeRole"
#    }]
#  })
#
#  managed_policy_arns = [
#    "arn:aws:iam::aws:policy/AWSCodeBuildAdminAccess"
#  ]
#
#  inline_policy {
#    name = "CodePipelinePolicy"
#    policy = jsonencode({
#      Version = "2012-10-17",
#      Statement = [
#        {
#          Effect = "Allow",
#          Action = [
#            "logs:CreateLogGroup",
#            "logs:CreateLogStream",
#            "logs:PutLogEvents",
#            "ecr:*"
#          ],
#          Resource = [
#            "arn:aws:logs:us-east-1:${var.account_id}:log-group:/aws/codebuild/CodeBuildRole",
#            "arn:aws:logs:us-east-1:${var.account_id}:log-group:/aws/codebuild/CodeBuildRole:*",
#            "*"
#          ]
#        },
#        {
#          Effect = "Allow",
#          Action = [
#            "s3:PutObject",
#            "s3:GetObject",
#            "s3:GetObjectVersion",
#            "s3:GetBucketAcl",
#            "s3:GetBucketLocation"
#          ],
#          Resource = [
#            "arn:aws:s3:::<BuckerName>*",
#            "arn:aws:s3:::<BuckerName>-*/*"
#          ]
#        },
#        {
#          Effect   = "Allow",
#          Action   = "ecr:GetAuthorizationToken",
#          Resource = "*"
#        },
#        {
#          Effect = "Allow",
#          Action = [
#            "codebuild:CreateReportGroup",
#            "codebuild:CreateReport",
#            "codebuild:UpdateReport",
#            "codebuild:BatchPutTestCases",
#            "codebuild:BatchPutCodeCoverages"
#          ],
#          Resource = [
#            "arn:aws:codebuild:us-east-1:${var.account_id}:report-group/CodeBuildRole-*"
#          ]
#        },
#        {
#          Effect = "Allow",
#          Action = "codebuild:*",
#          Resource = "*"
#        },
#        {
#          Effect = "Allow",
#          Action = [
#            "ecs:DescribeServices",
#            "ecs:UpdateService"
#          ],
#          Resource = "*"
#        }
#      ]
#    })
#  }
#}
##=======================END IAM==========================
#resource "aws_codebuild_project" "CodeBuildProject" {
#  name       = "CodeBuildProject"
#  service_role = aws_iam_role.CodeBuildRole.arn
#
#  source {
#    type = "GITHUB"
#    location = "https://github.com/<GitHubOwner>/<GitHubRepo>.git"
#    buildspec = "buildspec.yml"
#  }
#
#  artifacts {
#    type = "NO_ARTIFACTS"
#  }
#
#  environment {
#    type = "LINUX_CONTAINER"
#    compute_type = "BUILD_GENERAL1_SMALL"
#    image = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
#    privileged_mode = true
#  }
#}
##===========================END CODEBUILD=========================
#resource "aws_codepipeline_webhook" "GithubWebhook" {
#  authentication = "GITHUB_HMAC"
#
#  authentication_configuration {
#    secret_token = var.GitHubOAuthToken
#  }
#
#  register_with_third_party = true
#
#  target_action = aws_codepipeline.CodePipeline.stage[0].action[0].name
#  target_pipeline = aws_codepipeline.CodePipeline.name
##  target_pipeline_version = aws_codepipeline.CodePipeline.stage[0].action[0].configuration[0].output_artifacts[0].store[0].encryption_key_id
#
#  name = ""
#
#  filter {
#    json_path = "$.ref"
#    match_equals = "refs/heads/${var.GitHubBranch}"
#  }
#}
#
#resource "aws_codepipeline" "CodePipeline" {
#  name     = "ECS-Pipeline"
#  restart_execution_on_update = true
#
#  artifact_store {
#    type     = "S3"
#    location = var.BuckerName
#  }
#
#  role_arn = aws_iam_role.CodePipelineRole.arn
#
#  stage {
#    name = "Source"
#
#    action {
#      name = "Source"
#      category = "Source"
#      owner    = "ThirdParty"
#      version  = "1"
#      provider = "GitHub"
#
#      output_artifacts {
#        name = "SourceCode"
#      }
#
#      configuration = {
#        Owner              = var.GitHubOwner
#        Repo               = var.GitHubRepo
#        Branch             = var.GitHubBranch
#        PollForSourceChanges = false
#        OAuthToken        = var.GitHubOAuthToken
#      }
#
#      run_order = 1
#    }
#  }
#
#  stage {
#    name = "Build"
#
#    action {
#      name = "BuildAction"
#      category = "Build"
#      owner    = "AWS"
#      version  = "1"
#      provider = "CodeBuild"
#
#      input_artifacts {
#        name = "SourceCode"
#      }
#
#      configuration = {
#        ProjectName = aws_codebuild_project.CodeBuildProject.name
#      }
#
#      output_artifacts {
#        name = "BuildOutput"
#      }
#
#      run_order = 2
#    }
#  }
#}
##===============================ENDC CODEPIPELINE==============================
#resource "aws_sns_topic" "SnsTopicCodeBuild" {
#  name = "SnsTopicCodeBuild"
#
#  subscription {
#    endpoint = var.NotificationEmail
#    protocol = "email"
#  }
#}
##==================END SNS TOPIC===============================
#resource "aws_cloudwatch_event_rule" "EventBridgeRule" {
#  name = "CodeBuildEventRule"
#
#  event_pattern = jsonencode({
#    source = ["aws.codebuild"],
#    detail_type = ["Codebuild Build Phase Change"],
#    detail = {
#      completed_phase = ["SUBMITTED", "PROVISIONING", "DOWNLOAD_SOURCE", "INSTALL", "PRE_BUILD", "BUILD", "POST_BUILD", "UPLOAD_ARTIFACTS", "FINALIZING"],
#      completed_phase_status = ["TIMED_OUT", "STOPPED", "FAILED", "SUCCEEDED", "FAULT", "CLIENT_ERROR"],
#      project_name = [aws_codebuild_project.CodeBuildProject.name]
#    }
#  })
#
#  state     = "ENABLED"
#  role_arn  = aws_iam_role.SampleNotificationRuleRole.arn
#
#  target {
#    arn = aws_sns_topic.SnsTopicCodeBuild.arn
#    id  = "CodeBuildProject"
#
#    input_transformer {
#      input_paths_map = {
#        "build-id"                = "$.detail.build-id"
#        "project-name"            = "$.detail.project-name"
#        "completed-phase"         = "$.detail.completed-phase"
#        "completed-phase-status"  = "$.detail.completed-phase-status"
#      }
#
#      input_template = jsonencode("Build '<build-id>' for build project '<project-name>' has completed the build phase of '<completed-phase>' with a status of '<completed-phase-status>'.")
#    }
#  }
#}
##===========================END CLOUDWATCH================================================
#resource "aws_sns_topic_policy" "SnsTopicPolicy" {
#  topics = [aws_sns_topic.SnsTopicCodeBuild.arn]
#
#  policy = jsonencode({
#    Version = "2012-10-17",
#    Statement = [{
#      Effect = "Allow",
#      Principal = {
#        Service = "events.amazonaws.com"
#      },
#      Action = "sns:Publish",
#      Resource = aws_sns_topic.SnsTopicCodeBuild.arn
#    }]
#  })
#}
#
#resource "aws_iam_role" "SampleNotificationRuleRole" {
#  name = "SampleNotificationRuleRole"
#
#  assume_role_policy = jsonencode({
#    Version = "2012-10-17",
#    Statement = [{
#      Effect    = "Allow",
#      Principal = {
#        Service = "events.amazonaws.com"
#      },
#      Action = "sts:AssumeRole"
#    }]
#  })
#
#  inline_policy {
#    name = "sample-notification-rule-role-policy"
#    policy = jsonencode({
#      Version = "2012-10-17",
#      Statement = [
#        {
#          Effect = "Allow",
#          Action = "sns:Publish",
#          Resource = "*"
#        }
#      ]
#    })
#  }
#}
#
#output "ALBDNSName" {
#  description = "DNS name of the Application Load Balancer"
#  value       = aws_lb.LoadBalancer.dns_name
#}
#
#output "ECSServiceName" {
#  description = "ECS service name"
#  value       = aws_ecs_service.ECSService.name
#}
#
