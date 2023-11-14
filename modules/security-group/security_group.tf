
resource "aws_security_group" "SecurityGroup" {
  name        = "ECS-SG"
  description = "SecurityGroup for ECS"
  vpc_id      = var.vpc_id #aws_vpc.PrivateVPC.id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.alb_sg_id.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "ECS-SG"
  }
}

resource "aws_security_group" "alb_sg_id" {
  name        = "ALB-SG"
  description = "SecurityGroup for ECS"
  vpc_id      = var.vpc_id #aws_vpc.PrivateVPC.id

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "ALB-SG"
  }
}
#==============================END SG================================================
