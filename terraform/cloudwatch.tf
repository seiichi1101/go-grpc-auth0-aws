resource "aws_cloudwatch_log_group" "go_grpc_server_log" {
  name = replace("/ecs/${var.system_name}_${var.aws_env}/go_grpc_server_log", "_", "-")
}