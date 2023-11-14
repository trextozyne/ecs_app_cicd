
output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.LoadBalancer.dns_name
}

output "alb_target_group_arn" {
  value = aws_lb_target_group.TargetGroup.arn
}