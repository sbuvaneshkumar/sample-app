# Private subnets
resource "aws_subnet" "private" {
  cidr_block = element(var.subnet_cidrs.private, count.index)
  availability_zone_id = element(var.az_ids, count.index)
  count = length(var.subnet_cidrs.private)

  tags = {
    Name = "priv-az${count.index + 1}"
    env = var.environment
  }

  vpc_id = aws_vpc.main.id
}

# Public subnets
resource "aws_subnet" "public" {
  availability_zone_id = element(var.az_ids, count.index)
  cidr_block = element(var.subnet_cidrs.public, count.index)
  count = length(var.subnet_cidrs.public)

  tags = {
    env = var.environment
    Name = "pub-az${count.index + 1}"
  }

  vpc_id = aws_vpc.main.id
}
