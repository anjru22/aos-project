resource "aws_lb" "fleetcart-alb" {
  name                       = "FleetCart-ALB"
  internal                   = false
  load_balancer_type         = "application"
  ip_address_type            = "ipv4"
  security_groups            = [aws_security_group.alb-sg.id]
  subnets                    = [aws_subnet.pub-subnet-az1.id, aws_subnet.pub-subnet-az2.id]
  enable_deletion_protection = true

  tags = {
    Name = "FleetCart ALB"
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.fleetcart-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https-listener" {
  load_balancer_arn = aws_lb.fleetcart-alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:us-west-1:550592266861:certificate/0a04ba9e-6636-463c-9a4d-84a2c5a2d185"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.elb-tg.arn
  }
}