resource "aws_ecs_cluster" "main" {
  name = "ecs-cluster"
}

resource "aws_ecs_task_definition" "frontend" {
  family                   = "frontend"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  cpu                      = "256"
  memory                   = "512"
  container_definitions = jsonencode([{
    name  = "frontend"
    image = "${var.account_id}.dkr.ecr.ap-northeast-1.amazonaws.com/frontend:latest"
    portMappings = [{
      containerPort = 80
    }]
  }])
}

resource "aws_ecs_task_definition" "service_a" {
  family                   = "service-a"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  cpu                      = "256"
  memory                   = "512"
  container_definitions = jsonencode([{
    name  = "service-a"
    image = "${var.account_id}.dkr.ecr.ap-northeast-1.amazonaws.com/service-a:latest"
    portMappings = [{
      containerPort = 3000
    }]
  }])
}

resource "aws_ecs_task_definition" "service_b" {
  family                   = "service-b"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  cpu                      = "256"
  memory                   = "512"
  container_definitions = jsonencode([{
    name  = "service-b"
    image = "${var.account_id}.dkr.ecr.ap-northeast-1.amazonaws.com/service-b:latest"
    portMappings = [{
      containerPort = 3000
    }]
  }])
}

resource "aws_ecs_service" "frontend" {
  name            = "frontend-service"
  cluster         = aws_ecs_cluster.main.id
  launch_type     = "FARGATE"
  desired_count   = var.desired_count
  task_definition = aws_ecs_task_definition.frontend.arn

  network_configuration {
    subnets          = [aws_subnet.public_a.id, aws_subnet.public_c.id]
    security_groups  = [aws_security_group.ecs_task_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.frontend_tg.arn
    container_name   = "frontend"
    container_port   = 80
  }
}

resource "aws_ecs_service" "service_a" {
  name            = "service-a-service"
  cluster         = aws_ecs_cluster.main.id
  launch_type     = "FARGATE"
  desired_count   = var.desired_count
  task_definition = aws_ecs_task_definition.service_a.arn

  network_configuration {
    subnets          = [aws_subnet.public_a.id, aws_subnet.public_c.id]
    security_groups  = [aws_security_group.ecs_task_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.service_a_tg.arn
    container_name   = "service-a"
    container_port   = 3000
  }
}

resource "aws_ecs_service" "service_b" {
  name            = "service-b-service"
  cluster         = aws_ecs_cluster.main.id
  launch_type     = "FARGATE"
  desired_count   = var.desired_count
  task_definition = aws_ecs_task_definition.service_b.arn

  network_configuration {
    subnets          = [aws_subnet.public_a.id, aws_subnet.public_c.id]
    security_groups  = [aws_security_group.ecs_task_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.service_b_tg.arn
    container_name   = "service-b"
    container_port   = 3000
  }
}
