resource "aws_vpc" "dev-vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "dev-vpc"
  }
}

resource "aws_internet_gateway" "dev-igw" {
  vpc_id = aws_vpc.dev-vpc.id
  tags = {
    Name = "dev-vpc-igw"
  }
}

resource "aws_internet_gateway_attachment" "igw-attachment" {
  internet_gateway_id = aws_internet_gateway.dev-igw.id
  vpc_id = aws_vpc.dev-vpc.id
}

resource "aws_subnet" "public-subnet-az1" {
  vpc_id     = aws_vpc.dev-vpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-west-1a"

  tags = {
    Name = "public-subnet-az1"
  }
}

resource "aws_subnet" "public_subnet-az2" {
  vpc_id     = aws_vpc.dev-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-west-1b"

  tags = {
    Name = "public-subnet-az2"
  }
}