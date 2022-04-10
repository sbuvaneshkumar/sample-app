resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.environment
  }
}

output "subnets" {
  value = {
    "private": [
      for subnet in aws_subnet.private:
      {
        "alias": subnet.tags.Name,
        "cidr": subnet.cidr_block,
        "id": subnet.id
      }
    ],
    "public": [
      for subnet in aws_subnet.public:
      {
        "alias": subnet.tags.Name,
        "cidr": subnet.cidr_block,
        "id": subnet.id
      }
    ]
  }
}
