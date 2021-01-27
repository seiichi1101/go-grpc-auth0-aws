resource "aws_ecr_repository" "ecr_repo_go_grpc_server" {
  name = replace("${var.system_name}_${var.aws_env}_ecr_repo/go_grpc_server", "_", "-")
}

resource "aws_ecr_repository_policy" "ecr_repo_policy_go_grpc_server" {
  repository = aws_ecr_repository.ecr_repo_go_grpc_server.name

  policy = <<EOF
  {
    "Version": "2008-10-17",
    "Statement": [
      {
        "Sid": "new statement",
        "Effect": "Allow",
        "Principal": "*",
        "Action": [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer"
        ]
      }
    ]
  }
EOF
}
