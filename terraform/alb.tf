resource "aws_lb" "fleetcart-alb" {
  name                       = "FleetCart-ALB"
  internal                   = false
  load_balancer_type         = "application"
  ip_address_type            = "ipv4"
  security_groups            = [aws_security_group.alb-sg.id]
  subnets                    = [aws_subnet.pub-subnet-az1.id, aws_subnet.pub-subnet-az2.id]
  enable_deletion_protection = false

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

data "aws_acm_certificate" "fleetcart-cert" {
  domain = "andrewchu.us"
  statuses = ["ISSUED"]
}

resource "aws_lb_listener" "https-listener" {
  load_balancer_arn = aws_lb.fleetcart-alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.fleetcart-cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.elb-tg.arn
  }
}
