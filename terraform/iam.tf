# For ECS Exec
resource "aws_iam_role" "ecs_exec_role" {
  name               = replace("${var.system_name}_${var.aws_env}_ecs_exec_role", "_", "-")
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
    },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs_task_exec_policy" {
  role       = aws_iam_role.ecs_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# For ECS Task
resource "aws_iam_role" "ecs_task_role" {
  name               = replace("${var.system_name}_${var.aws_env}_ecs_task_role", "_", "-")
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
          "ecs-tasks.amazonaws.com",
          "ssm.amazonaws.com"
        ]
    },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}


