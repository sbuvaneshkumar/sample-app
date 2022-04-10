resource "aws_ecs_cluster" "main" {
  name = join("", [var.app_name,"-cluster"])
  tags = {
    Name = join("", [var.app_name,"-cluster"])
  }
}

resource "aws_ecs_task_definition" "main" {
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  family                   = join("", [var.app_name,"-task"])
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn 
  container_definitions = jsonencode([{
    name        = var.app_name
    image       = join("", [var.ecr_repo_url, ":",var.app_image_tag])
    essential   = true
    portMappings = [{
      protocol      = "tcp"
      containerPort = var.container_port
      hostPort      = var.container_port
    }]
  }])
}

resource "aws_ecs_service" "main" {
 name                               = join("", [var.app_name,"-service"])
 launch_type                        = "FARGATE"
 scheduling_strategy                = "REPLICA"
 desired_count                      = 2
 cluster                            = aws_ecs_cluster.main.id
 task_definition                    = aws_ecs_task_definition.main.arn
 deployment_minimum_healthy_percent = 100
 deployment_maximum_percent         = 200

 network_configuration {
   security_groups  = var.ecs_service_security_groups
   subnets          = var.private_subnets.*.id
   assign_public_ip = false
 }

 load_balancer {
   target_group_arn = var.aws_alb_target_group_arn
   container_name   = var.app_name
   container_port   = var.container_port
 }

 lifecycle {
   ignore_changes = [desired_count]
 }
}
