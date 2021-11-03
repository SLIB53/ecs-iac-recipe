resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/27"

  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_internet_gateway" "public_gateway" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.main.id

  route {
    gateway_id = aws_internet_gateway.public_gateway.id
    cidr_block = "0.0.0.0/0"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.main.id

  cidr_block = "10.0.0.0/25"
}

resource "aws_route_table_association" "public_route_subnet_association" {
  route_table_id = aws_route_table.public_route.id
  subnet_id      = aws_subnet.public_subnet.id
}
