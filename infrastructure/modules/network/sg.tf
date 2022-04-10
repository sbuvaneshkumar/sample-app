resource "aws_security_group" "alb" {
  name   = join("",[var.app_name, "-sg-alb"])
  vpc_id = aws_vpc.main.id

  ingress {
    protocol         = "tcp"
    from_port        = 80
    to_port          = 80
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    protocol         = "tcp"
    from_port        = 443
    to_port          = 443
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = join("",[var.app_name, "-sg-alb"])
  }
}

resource "aws_security_group" "ecs_tasks" {
  name   = join("",[var.app_name, "-sg-task"])
  vpc_id = aws_vpc.main.id

  ingress {
    protocol         = "tcp"
    from_port        = 8080
    to_port          = 8080
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = join("",[var.app_name, "-sg-task"])
  }
}

output "security_group_alb_id" {
  value = aws_security_group.alb.id
}

output "security_group_ecs_tasks_id" {
  value = aws_security_group.ecs_tasks.id
}
