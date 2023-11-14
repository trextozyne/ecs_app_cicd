
resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name = "${var.env}-logs"

  tags = {
    Application = var.ecs_app_name
    Environment = var.env
  }
}