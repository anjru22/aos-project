resource "aws_lb_target_group" "elb-tg" {
  name     = "load-balancer-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.dynamic-app-vpc.id
  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200,301,302" # Health check success status codes
    timeout             = 120           #5 (Original Value)
    interval            = 125           #30 (Original Value)
    healthy_threshold   = 10            #5 (Original Value)
    unhealthy_threshold = 10            #2 (Original Value)
  }
}
