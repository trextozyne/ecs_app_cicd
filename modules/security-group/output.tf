
output "sg_id" {
  value = aws_security_group.SecurityGroup.id
}

output "alb_sg_id" {
  value = aws_security_group.alb_sg_id.id
}