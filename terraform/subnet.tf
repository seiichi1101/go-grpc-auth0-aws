resource "aws_subnet" "pub_subnet_a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = replace("${var.system_name}_${var.aws_env}_pub_subnet_a", "_", "-")
  }
}

resource "aws_subnet" "pub_subnet_c" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = true
  tags = {
    Name = replace("${var.system_name}_${var.aws_env}_pub_subnet_c", "_", "-")
  }
}
