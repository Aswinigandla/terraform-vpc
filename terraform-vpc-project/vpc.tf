data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "vcube139" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

resource "aws_subnet" "vcube139_publicsubnet" {
  vpc_id                  = aws_vpc.vcube139.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-publicsubnet"
    Tier = "Public"
  }
}

resource "aws_subnet" "vcube139_prvsubnet" {
  vpc_id            = aws_vpc.vcube139.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${var.project_name}-prvsubnet"
    Tier = "Private"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vcube139.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

# Public route table: send internet-bound traffic to the Internet Gateway.
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vcube139.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.vcube139_publicsubnet.id
  route_table_id = aws_route_table.public_rt.id
}

# Elastic IP and NAT Gateway are placed in the public subnet.
resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "${var.project_name}-nat-eip"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.vcube139_publicsubnet.id

  depends_on = [aws_internet_gateway.gw]

  tags = {
    Name = "${var.project_name}-nat-gateway"
  }
}

# Private route table: send internet-bound traffic through the NAT Gateway.
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vcube139.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "${var.project_name}-private-rt"
  }
}

resource "aws_route_table_association" "private_association" {
  subnet_id      = aws_subnet.vcube139_prvsubnet.id
  route_table_id = aws_route_table.private_rt.id
}
