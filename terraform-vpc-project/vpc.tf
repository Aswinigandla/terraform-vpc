resource "aws_vpc" "vcube139" {
  cidr_block       = "110.0.0.0/16"

  tags = {
    Name = "vcube139-vpc"
  }
}
resource "aws_subnet" "vcube139-publicsubnet" {
  vpc_id     = aws_vpc.vcube139.id
  cidr_block = "110.0.0.0/24"

  tags = {
    Name = "vcube139-publicsubnet"
  }
}
resource "aws_subnet" "vcube139-prvsubnet" {
  vpc_id     = aws_vpc.vcube139.id
  cidr_block = "110.0.23.0/24"

  tags = {
    Name = "vcube139-prvsubnet"
  }
}
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vcube139.id

  tags = {
    Name = "vcube139-igw"
  }
}
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vcube139.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "vcube139-public-rt"
  }
}
resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.vcube139-publicsubnet.id
  route_table_id = aws_route_table.public_rt.id
}
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vcube139.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "vcube139-private-rt"
  }
}
resource "aws_route_table_association" "private_association" {
  subnet_id      = aws_subnet.vcube139-prvsubnet.id
  route_table_id = aws_route_table.private_rt.id
}
resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "vcube139-nat-eip"
  }
}
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.vcube139-publicsubnet.id

  tags = {
    Name = "vcube139-nat-gateway"
  }

  depends_on = [aws_internet_gateway.gw]
}
