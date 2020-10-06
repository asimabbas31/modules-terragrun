resource "aws_lb" "mq" {
  name                             = "rabbitmq-${var.env}"
  internal                         = false
  load_balancer_type               = "network"
  enable_deletion_protection       = false
  enable_cross_zone_load_balancing = true
  ip_address_type                  = "ipv4" # cannot dual stack with specified addresses

  subnets = var.public_subnet
  tags = {
    Name        = "rabbitmq"
    source      = "terraform"
    project     = "API"
    env        = var.env
  }
}

# docs: https://aws.amazon.com/premiumsupport/knowledge-center/security-group-load-balancer/
# per docs, the SG is attached to the target instances (or the redis instances, in this case)
# when using an NLB

resource "aws_security_group" "rabbitmq" {
  name        = "rabbitmq loadbalancer"
  description = "rabbitmq ${var.env}"
  vpc_id      = var.vpcid

  ingress {
    from_port   = 15672
    to_port     = 15672
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    from_port   = 5672
    to_port     = 5672
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "Rabbitmq loadbalancer"
    source      = "terraform"
    project     = "API"
    env          = var.env
  }
}


# the protocol is technically TLS rather than basic TCP, however we go from
# internet --> LB --> TLS, so this will simply forward dumb TCP.

resource "aws_lb_target_group" "rabbitmqhttp" {
  protocol    = "TCP"
  port        = 15672
  target_type = "instance"
  vpc_id      = var.vpcid
  tags = {
    Name        = "rabbitmq"
    source      = "terraform"
    project     = "API"
    env = var.env
  }
  health_check {
    enabled             = true
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 10
  }
}


resource "aws_lb_target_group" "rabbitmqport" {
  protocol    = "TCP"
  port        = 5672
  target_type = "instance"
  vpc_id      = var.vpcid
  tags = {
    Name        = "rabbitmqport"
    source      = "terraform"
    project     = "API"
    env = var.env
  }
  health_check {
    enabled             = true
    protocol            = "TCP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 10
  }
}




resource "aws_lb_listener" "rabbitmqhttp" {
  load_balancer_arn = aws_lb.mq.arn
  protocol          = "TCP"
  port              = 15672
  default_action {
    target_group_arn = aws_lb_target_group.rabbitmqhttp.arn
    type             = "forward"
  }
}



resource "aws_lb_listener" "rabbitmqport" {
  load_balancer_arn = aws_lb.mq.arn
  protocol          = "TCP"
  port              = 5672
  default_action {
    target_group_arn = aws_lb_target_group.rabbitmqport.arn
    type             = "forward"
  }
}



resource "aws_autoscaling_attachment" "albapple" {
  autoscaling_group_name = aws_autoscaling_group.apple.id
  alb_target_group_arn   = aws_lb_target_group.rabbitmqhttp.arn
}
