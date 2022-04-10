# Route table for private subnets
resource "aws_route_table" "private" {
  count  = length(var.subnet_cidrs.private)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.main.*.id, count.index)
  }
}

resource "aws_route_table_association" "private" {
  count          = length(var.subnet_cidrs.private)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)

  depends_on = [
    aws_route_table.private
  ]
}

# Route table for public subnet
resource "aws_route_table" "public" {
  count = length(var.subnet_cidrs.public)

  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    env = "dev",
    Name = "public-az${count.index + 1}"
  }
}

resource "aws_route_table_association" "public" {
  count = length(var.subnet_cidrs.public)

  depends_on = [
    aws_route_table.public
  ]

  route_table_id = element(aws_route_table.public.*.id, count.index)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
}
