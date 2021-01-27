resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = replace("${var.system_name}_${var.aws_env}_igw", "_", "-")
  }
}
