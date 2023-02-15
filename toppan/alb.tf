# #* Create an Application Load Balancer
resource "aws_lb" "jazz_alb" {
  name               = "jazz-toppan-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.jazz_elastic_lb_sec_grp.id]
  // NEED TO CHECK THE MAPPINGS
  subnet_mapping {
    subnet_id = aws_subnet.alb_public_subnet.id
  }
  subnet_mapping {
    subnet_id = aws_subnet.serverfleet_private_subnet.id
  }

  enable_deletion_protection = false
  tags = {
    Name = "jazz_alb"
  }
}


# #* Create Target Group
resource "aws_lb_target_group" "jazz_alb_target_group" {
  name        = "jazsley-alb-tg"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.jazz_toppan_vpc.id

  health_check {
    healthy_threshold   = 5
    interval            = 30
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }

  tags = {
    Name = "jazz-alb-target-group"
  }
}


resource "aws_autoscaling_attachment" "terramino" {
  autoscaling_group_name = aws_autoscaling_group.fleet_a_asg.id
  lb_target_group_arn   = aws_lb_target_group.jazz_alb_target_group.arn
  depends_on = [
    aws_autoscaling_group.fleet_a_asg
  ]
}




# #* Create a Listener on Port 80 for load balancer

resource "aws_lb_listener" "jazz_alb_listener_HTTP" {
  load_balancer_arn = aws_lb.jazz_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jazz_alb_target_group.arn
  }

  tags = {
    Name = "jazz_alb_listener_HTTP"
  }
}
