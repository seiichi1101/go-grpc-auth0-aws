resource "aws_alb" "alb" {
  name = replace("${var.system_name}_${var.aws_env}_alb", "_", "-")

  security_groups = [aws_security_group.alb_sg.id]
  subnets = [
    aws_subnet.pub_subnet_a.id,
    aws_subnet.pub_subnet_c.id,
  ]
  internal                   = false
  enable_deletion_protection = false

}

resource "aws_alb_listener" "grpc" {
  load_balancer_arn = aws_alb.alb.arn
  port              = 50051
  protocol          = "HTTPS"

  certificate_arn = data.aws_acm_certificate.main.arn


  default_action {
    order = 99
    type  = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "500 INTERNAL SERVER ERROR"
      status_code  = "500"
    }
  }
}

resource "aws_alb_listener_rule" "go_grpc_server" {
  listener_arn = aws_alb_listener.grpc.arn

  priority = 1

  action {
    type = "forward"
    target_group_arn = aws_alb_target_group.go_grpc_server_target_gp.arn
  }

  condition {
    path_pattern {
      values = [
        "/*",
      ]
    }
  }
}

resource "aws_alb_target_group" "go_grpc_server_target_gp" {
  port                 = 50051
  protocol             = "HTTP"
  protocol_version     = "GRPC"

  vpc_id      = aws_vpc.vpc.id
  target_type = "ip"

  health_check {
    interval = 60
    path     = "/helloworld.Greeter/SayHello"

    protocol            = "HTTP"
    timeout             = 20
    unhealthy_threshold = 4
    matcher             = "0-99"
  }
  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_alb.alb]
  tags = {
    Name = replace("${var.system_name}_${var.aws_env}_go_grpc_server_target_gp", "_", "-")
  }
}



