# Application Load Balancer
resource "aws_lb" "main" {
  name               = "ecs-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public_a.id, aws_subnet.public_c.id]
}

# Target Groups
resource "aws_lb_target_group" "frontend_tg" {
  name        = "frontend-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.main.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

resource "aws_lb_target_group" "service_a_tg" {
  name        = "service-a-tg"
  port        = 3000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.main.id

  health_check {
    path                = "/api/service-a"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

resource "aws_lb_target_group" "service_b_tg" {
  name        = "service-b-tg"
  port        = 3000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.main.id

  health_check {
    path                = "/api/service-b"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

# Listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend_tg.arn
  }
}

# Path-based routing rules
resource "aws_lb_listener_rule" "service_a_rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["/api/service-a", "/api/service-a/"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.service_a_tg.arn
  }
}

resource "aws_lb_listener_rule" "service_b_rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 200

  condition {
    path_pattern {
      values = ["/api/service-b", "/api/service-b/"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.service_b_tg.arn
  }
}
