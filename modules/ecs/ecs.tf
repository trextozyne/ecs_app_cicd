
resource "aws_service_discovery_private_dns_namespace" "ecs_private_dns" {
  name        = var.service_discovery_private_dns_name
  description = "ecs public dns"
  vpc         = var.vpc_id
}

resource "aws_service_discovery_http_namespace" "ecs_service_discovery_namespace" {
  name        = "ECSClusterNamespace"
  description = "ECSCluster namespace"
}

#resource "aws_service_discovery_service" "ecs_service_discovery" {
#  name = var.ecs_service_discovery
#
#  dns_config {
#    namespace_id = aws_service_discovery_private_dns_namespace.ecs_private_dns.id
#    dns_records {
#      ttl = 10
#      type = "A" #"SRV"
#    }
#
#    routing_policy = "MULTIVALUE"
#  }
#
##  health_check_config {
##    failure_threshold = 10
##    resource_path     = "path"
##    type              = "HTTP"
##  }
#
#  health_check_custom_config {
#    failure_threshold = 2
#  }
#}

resource "aws_ecr_repository" "MyECRRepository" {
  name = var.image_name

  image_scanning_configuration {
    scan_on_push = true
  }

  image_tag_mutability = "MUTABLE"
}

resource "aws_ecs_cluster" "ECSCluster" {
  name = "ECS-Cluster-FlaskApp"

  configuration {
    execute_command_configuration {
      logging = "DEFAULT"
    }
  }

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  service_connect_defaults {
    namespace = aws_service_discovery_http_namespace.ecs_service_discovery_namespace.arn
  }
}

#resource "aws_ecs_cluster_capacity_providers" "capacity_providers" {
#  cluster_name = aws_ecs_cluster.ECSCluster.name
#  capacity_providers = ["FARGATE_SPOT", "FARGATE"]
#
#  default_capacity_provider_strategy {
#    capacity_provider = "FARGATE_SPOT"
#  }
#}

resource "aws_ecs_task_definition" "ecs_service" {
  family                   = "TaskDefinationECS-Service"
  network_mode             = "awsvpc"
  execution_role_arn       = var.ecs_task_execution_iam_role_arn
  # use diffrent roles for this 2 in order to follow principles of less privilege
  task_role_arn            = var.ecs_task_execution_iam_role_arn
  cpu                      = "1024"
  memory                   = "3072"
  requires_compatibilities = ["FARGATE"]

  container_definitions = jsonencode([{
    name   = var.ecs_app_name
    image  = var.ecs_image_location
    cpu    = 1024
    memory = 3072

    logConfiguration = {
      logDriver = "awslogs",
      options = {
           "awslogs-group" = var.cloudwatch_loggroup_id
           "awslogs-region" = var.region
           "awslogs-stream-prefix" = "${var.ecs_app_name}-${var.env}"
      }
    }

    portMappings = var.ecs_portMappings

    essential = true

    environment = [
      {
        name  = "NAME"
        value = "World"
      }
    ]

    environmentFiles = []
    mountPoints      = []
    volumesFrom      = []
    limits          = []
  }])

  runtime_platform {
    cpu_architecture       = "X86_64"
    operating_system_family = "LINUX"
  }
}

resource "aws_ecs_service" "ECSService" {
  name            = var.ecs_service_name
  cluster         = aws_ecs_cluster.ECSCluster.id
  task_definition = aws_ecs_task_definition.ecs_service.family #var.task_definition_path = "../../env/dev/taskdefinitionecs/TaskDefinatioECS-Service.json
  launch_type     = var.ecs_service_launch_type
  scheduling_strategy = var.ecs_service_scheduling_strategy
  desired_count  = var.ecs_service_desired_count
  force_new_deployment = true

  load_balancer {
    container_name   = var.ecs_service_load_balancer["container_name"]
    container_port   = var.ecs_service_load_balancer["container_port"]
    target_group_arn = var.alb_target_group_arn
  }

  network_configuration {
    assign_public_ip = true
    security_groups = [var.sg_id]
    subnets = [var.private_subnet_1, var.private_subnet_2]
  }

  deployment_controller {
    type = "ECS"
  }

  platform_version = "LATEST"

  deployment_minimum_healthy_percent = var.ecs_service_deployment_minimum_healthy_percent
  deployment_maximum_percent         = var.ecs_service_deployment_maximum_percent
  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

#  service_registries {
#    registry_arn = aws_service_discovery_service.ecs_service_discovery.arn
##    port = var.ecs_service_service_registries["port"]
#    container_name = var.ecs_service_service_registries["container_name"]
##    container_port = var.ecs_service_service_registries["container_port"]
#  }

  enable_ecs_managed_tags = true
}

#===================================END ECS============================================

#resource "aws_codestarconnections_connection" "nnn" {
#
#  name = ""
#}