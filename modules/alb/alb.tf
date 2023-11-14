
resource "aws_lb" "LoadBalancer" {
  name               = "ALB-ECS-Service"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = [var.public_subnet_1, var.public_subnet_2]
}

resource "aws_lb_target_group" "TargetGroup" {
  name     = "ECS-TG"
  port     = 80
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = var.vpc_id

  health_check {
    path     = "/healthz"
    healthy_threshold   = "3"
    interval            = "300"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "35"
    unhealthy_threshold = "2"
  }
}

resource "aws_lb_listener" "Listener" {
  load_balancer_arn = aws_lb.LoadBalancer.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.TargetGroup.id
  }
}

#=============================END LOADBALANCER===========================
