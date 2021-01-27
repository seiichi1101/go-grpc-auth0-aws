resource "aws_ecs_cluster" "ecs_cluster" {
  name = replace("${var.system_name}_${var.aws_env}_ecs_cluster", "_", "-")

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

data "template_file" "go_grpc_server_task" {
  template = file("task-definitions/go-grpc-server-service.json")

  vars = {
    repo_url_prefix  = "${var.aws_account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.system_name}-${var.aws_env}-ecr-repo"
    log_group_prefix = "/ecs/${var.system_name}-${var.aws_env}"
  }
}

resource "aws_ecs_task_definition" "ecs_go_grpc_server_task" {
  family                   = replace("${var.system_name}_${var.aws_env}_ecs_go_grpc_server_task", "_", "-")
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  execution_role_arn       = aws_iam_role.ecs_exec_role.arn
  container_definitions    = data.template_file.go_grpc_server_task.rendered
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 1024
  requires_compatibilities = ["FARGATE"]

}

resource "aws_ecs_service" "go_grpc_server_ecs_service" {
  name             = replace("${var.system_name}_${var.aws_env}_go_grpc_server_ecs_service", "_", "-")
  cluster          = aws_ecs_cluster.ecs_cluster.id
  launch_type      = "FARGATE"
  platform_version = "1.4.0"

  task_definition = aws_ecs_task_definition.ecs_go_grpc_server_task.arn
  desired_count   = 1

  load_balancer {
    # target_group_arn = aws_alb_target_group.go_grpc_server_target_gp.arn
    target_group_arn = data.aws_lb_target_group.go_grpc_server_target_gp.arn
    container_name   = "go_grpc_server"
    container_port   = 50051
  }

  network_configuration {
    subnets = [
      aws_subnet.pub_subnet_a.id,
      aws_subnet.pub_subnet_c.id,
    ]

    security_groups = [
      aws_security_group.ecs_sg.id,
    ]

    assign_public_ip = "true"
  }
}
