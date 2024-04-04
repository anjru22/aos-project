resource "aws_launch_template" "fleetcart-launch-template" {
  name                   = "fleetcart-launch-template"
  image_id               = var.ami_image
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web-server-sg.id]
  tags = {
    Name = "fleetcart launch template"
  }
}

resource "aws_autoscaling_group" "fleetcart-asg" {
  vpc_zone_identifier       = [aws_subnet.priv-app-subnet-az1.id, aws_subnet.priv-app-subnet-az2.id]
  desired_capacity          = 2
  max_size                  = 3
  min_size                  = 1
  target_group_arns         = [aws_lb_target_group.elb-tg.arn]
  health_check_grace_period = 300
  health_check_type         = "ELB"
  name                      = "fleetcart asg"
  tag {
    key                 = "Name"
    value               = "ASG-Server"
    propagate_at_launch = true
  }

  launch_template {
    id      = aws_launch_template.fleetcart-launch-template.id
    version = "$Latest"
  }
}