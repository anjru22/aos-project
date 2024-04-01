# alb (public subnet) security group allowing http/s traffic from internet
resource "aws_security_group" "alb-sg" {
  name        = "alb sg"
  vpc_id      = aws_vpc.dynamic-app-vpc.id
  description = "allow http and https"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1" # aka all ports
  }

  tags = {
    Name = "alb sg"
  }
}

# ssh security group allowing connections from within the VPC
resource "aws_security_group" "ssh-sg" {
  name        = "ssh sg"
  vpc_id      = aws_vpc.dynamic-app-vpc.id
  description = "allow ssh from within the vpc"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${aws_vpc.dynamic-app-vpc.cidr_block}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1" # aka all ports
  }

  tags = {
    Name = "ssh sg"
  }
}

# web server security group (private subnet) allowing traffic from the alb/public subnet
resource "aws_security_group" "web-server-sg" {
  vpc_id      = aws_vpc.dynamic-app-vpc.id
  name        = "web server sg"
  description = "allow traffic from alb sg"

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb-sg.id]
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.alb-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1" # aka all ports
  }

  tags = {
    Name = "web server sg"
  }
}

# database security group (private subnet) allowing sql traffic from the web server sg
resource "aws_security_group" "db-sg" {
  vpc_id      = aws_vpc.dynamic-app-vpc.id
  name        = "databse sg"
  description = "database sg allows traffic from web server sg"

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.web-server-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1" # aka all ports
  }

  tags = {
    Name = "database sg"
  }
}
