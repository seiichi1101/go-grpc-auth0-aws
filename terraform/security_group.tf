resource "aws_security_group" "ecs_sg" {
  name   = replace("${var.system_name}_${var.aws_env}_ecs_sg", "_", "-")
  vpc_id = aws_vpc.vpc.id
}

resource "aws_security_group_rule" "ecs_sg_in_rule_grpc_from_alb" {
  type                     = "ingress"
  from_port                = 50051
  to_port                  = 50051
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb_sg.id
  security_group_id        = aws_security_group.ecs_sg.id
}

resource "aws_security_group_rule" "ecs_sg_out_rule_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ecs_sg.id
}

resource "aws_security_group" "alb_sg" {
  name   = replace("${var.system_name}_${var.aws_env}_alb_sg", "_", "-")
  vpc_id = aws_vpc.vpc.id
}


resource "aws_security_group_rule" "alb_sg_in_rule_grpc" {
  type              = "ingress"
  from_port         = 50051
  to_port           = 50051
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_sg.id
}

resource "aws_security_group_rule" "alb_sg_out_rule_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_sg.id
}
