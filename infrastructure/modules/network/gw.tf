# NAT gateway
resource "aws_nat_gateway" "main" {
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  allocation_id = element(aws_eip.nat.*.id, count.index)
  count         = length(var.subnet_cidrs.private)
  depends_on    = [
    aws_internet_gateway.main
  ]
}

resource "aws_eip" "nat" {
  count = length(var.subnet_cidrs.private)
  vpc = true
}

# Internet gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    env = var.environment 
    Name = var.app_name
  }
}
