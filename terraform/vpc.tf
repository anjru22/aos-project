# VPC
resource "aws_vpc" "dev-vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "dev vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "dev-igw" {
  vpc_id = aws_vpc.dev-vpc.id
  tags = {
    Name = "dev vpc igw"
  }
}

# Public Subnet AZ 1
resource "aws_subnet" "pub-subnet-az1" {
  vpc_id     = aws_vpc.dev-vpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-west-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public subnet az 1"
  }
}

# Public Subnet AZ 2
resource "aws_subnet" "pub-subnet-az2" {
  vpc_id     = aws_vpc.dev-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-west-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public subnet az 2"
  }
}

# Private App Subnet AZ 1
resource "aws_subnet" "priv-app-subnet-az1" {
  vpc_id = aws_vpc.dev-vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-west-1a"

  tags = {
    Name = "private app subnet az 1"
  }
}

# Private App Subnet AZ 2
resource "aws_subnet" "priv-app-subnet-az2" {
  vpc_id = aws_vpc.dev-vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-west-1b"

  tags = {
    Name = "private app subnet az 2"
  }
}

# Private Data Subnet AZ 1
resource "aws_subnet" "priv-data-subnet-az1" {
  vpc_id = aws_vpc.dev-vpc.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "us-west-1a"

  tags = {
    Name = "private data subnet az 1"
  }
}

# Private Data Subnet AZ 2
resource "aws_subnet" "priv-data-subnet-az2" {
  vpc_id = aws_vpc.dev-vpc.id
  cidr_block = "10.0.5.0/24"
  availability_zone = "us-west-1b"

  tags = {
    Name = "private data subnet az 2"
  }
}

# Public Route Table
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.dev-vpc.id

  tags = {
    Name = "public route table"
  }
}

# Routing internet traffic to the IGW
resource "aws_route" "public-route" {
  route_table_id = aws_route_table.public-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.dev-igw.id
}

# Associating public route table with public subnet az 1
resource "aws_route_table_association" "public-rt-association-az1" {
  route_table_id = aws_route_table.public-rt.id
  subnet_id = aws_subnet.pub-subnet-az1.id
}

# Associating public route table with public subnet az 2
resource "aws_route_table_association" "public-rt-association-az2" {
  route_table_id = aws_route_table.public-rt.id
  subnet_id = aws_subnet.pub-subnet-az2.id
}
