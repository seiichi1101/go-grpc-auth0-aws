resource "aws_route_table" "pub_route_tbl" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = replace("${var.system_name}_${var.aws_env}_pub_route_tbl", "_", "-")
  }
}

resource "aws_route_table_association" "pub_subnet_a" {
  subnet_id      = aws_subnet.pub_subnet_a.id
  route_table_id = aws_route_table.pub_route_tbl.id
}

resource "aws_route_table_association" "pub_subnet_c" {
  subnet_id      = aws_subnet.pub_subnet_c.id
  route_table_id = aws_route_table.pub_route_tbl.id
}
