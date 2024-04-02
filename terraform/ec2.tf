resource "aws_instance" "fleetcart-az1" {
  instance_type = "t2.micro"
  ami = "ami-005c5f98fa2c776eb"
  availability_zone = "us-west-1a"
  subnet_id = aws_subnet.priv-app-subnet-az1.id
  vpc_security_group_ids = [ aws_security_group.web-server-sg.id ]
  tags = {
    Name = "FleetCart Web Server AZ 1"
  }
}

resource "aws_instance" "fleetcart-az2" {
  instance_type = "t2.micro"
  ami = "ami-005c5f98fa2c776eb"
  availability_zone = "us-west-1b"
  subnet_id = aws_subnet.priv-app-subnet-az2.id
  vpc_security_group_ids = [ aws_security_group.web-server-sg.id ]
  tags = {
    Name = "FleetCart Web Server AZ 2"
  }
}