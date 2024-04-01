# VPC
resource "aws_vpc" "dynamic-app-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "dynamic app vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "dynamic-app-vpc-igw" {
  vpc_id = aws_vpc.dynamic-app-vpc.id
  tags = {
    Name = "dynamic app vpc igw"
  }
}

# Create Elastic IP for NAT Gateway 1 to use
resource "aws_eip" "nat_gateway_eip_az1" {
  depends_on = [aws_internet_gateway.dynamic-app-vpc-igw]

  tags = {
    Name = "elastic ip for ngw 1"
  }
}

# Creaete Elastic IP for NAT Gateway 2 to use
resource "aws_eip" "nat_gateway_eip_az2" {
  depends_on = [aws_internet_gateway.dynamic-app-vpc-igw]

  tags = {
    Name = "elastic ip for ngw 2"
  }
}

# NAT Gateway AZ 1
resource "aws_nat_gateway" "ngw-az1" {
  subnet_id     = aws_subnet.pub-subnet-az1.id
  allocation_id = aws_eip.nat_gateway_eip_az1.id

  tags = {
    Name = "public subnet az 1 ngw"
  }
}

# NAT Gateway AZ 2
resource "aws_nat_gateway" "ngw-az2" {
  subnet_id     = aws_subnet.pub-subnet-az2.id
  allocation_id = aws_eip.nat_gateway_eip_az2.id

  tags = {
    Name = "public subnet az 2 ngw"
  }
}

# Public Subnet AZ 1
resource "aws_subnet" "pub-subnet-az1" {
  vpc_id                  = aws_vpc.dynamic-app-vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-west-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public subnet az 1"
  }
}

# Public Subnet AZ 2
resource "aws_subnet" "pub-subnet-az2" {
  vpc_id                  = aws_vpc.dynamic-app-vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public subnet az 2"
  }
}

# Private App Subnet AZ 1
resource "aws_subnet" "priv-app-subnet-az1" {
  vpc_id            = aws_vpc.dynamic-app-vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-1a"

  tags = {
    Name = "private app subnet az 1"
  }
}

# Private App Subnet AZ 2
resource "aws_subnet" "priv-app-subnet-az2" {
  vpc_id            = aws_vpc.dynamic-app-vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-west-1b"

  tags = {
    Name = "private app subnet az 2"
  }
}

# Private Data Subnet AZ 1
resource "aws_subnet" "priv-data-subnet-az1" {
  vpc_id            = aws_vpc.dynamic-app-vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-west-1a"

  tags = {
    Name = "private data subnet az 1"
  }
}

# Private Data Subnet AZ 2
resource "aws_subnet" "priv-data-subnet-az2" {
  vpc_id            = aws_vpc.dynamic-app-vpc.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "us-west-1b"

  tags = {
    Name = "private data subnet az 2"
  }
}

# Public Route Table
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.dynamic-app-vpc.id

  tags = {
    Name = "public route table"
  }
}

# Private Route Table AZ 1
resource "aws_route_table" "private-rt-az1" {
  vpc_id = aws_vpc.dynamic-app-vpc.id

  tags = {
    Name = "private route table az1"
  }
}

# Private Route Table AZ 2
resource "aws_route_table" "private-rt-az2" {
  vpc_id = aws_vpc.dynamic-app-vpc.id

  tags = {
    Name = "private route table az2"
  }
}

# Routing internet traffic to the IGW
resource "aws_route" "public-route" {
  route_table_id         = aws_route_table.public-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.dynamic-app-vpc-igw.id
}


# Route internet-bound traffic to NAT Gateway 1
resource "aws_route" "private-route-az1" {
  route_table_id         = aws_route_table.private-rt-az1.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.ngw-az1.id
}

# Route internet-bound traffic to NAT Gateway 2
resource "aws_route" "private-route-az2" {
  route_table_id         = aws_route_table.private-rt-az2.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.ngw-az2.id
}

# Associating public route table with public subnet az 1
resource "aws_route_table_association" "public-rt-association-az1" {
  route_table_id = aws_route_table.public-rt.id
  subnet_id      = aws_subnet.pub-subnet-az1.id
}

# Associating public route table with public subnet az 2
resource "aws_route_table_association" "public-rt-association-az2" {
  route_table_id = aws_route_table.public-rt.id
  subnet_id      = aws_subnet.pub-subnet-az2.id
}

# Associating private route table with private app subnet az 1
resource "aws_route_table_association" "private-rt-app-association-az1" {
  route_table_id = aws_route_table.private-rt-az1.id
  subnet_id      = aws_subnet.priv-app-subnet-az1.id
}

# Associating private route table with private app subnet az 2
resource "aws_route_table_association" "private-rt-app-association-az2" {
  route_table_id = aws_route_table.private-rt-az2.id
  subnet_id      = aws_subnet.priv-app-subnet-az2.id
}

# Associating private route table with private data subnet az 1
resource "aws_route_table_association" "private-rt-data-association-az1" {
  route_table_id = aws_route_table.private-rt-az1.id
  subnet_id      = aws_subnet.priv-data-subnet-az1.id
}

# Associating private route table with private data subnet az 2
resource "aws_route_table_association" "private-rt-data-association-az2" {
  route_table_id = aws_route_table.private-rt-az2.id
  subnet_id      = aws_subnet.priv-data-subnet-az2.id
}
