terraform {
  required_version = ">= 0.12"
}

terraform {
  # Intentionally empty. Will be filled by Terragrunt.
  backend "s3" {}
}



resource "aws_acm_certificate" "certpayment" {
  domain_name       = var.domainname
  validation_method = "DNS"

  tags = {
    env = var.env
    Name = var.app
    source = "terrform"
  }

  lifecycle {
    create_before_destroy = true
  }
}



resource "aws_lb_target_group" "apple" {
  protocol    = "HTTP"
  port        = 8080
  target_type = "instance"
  vpc_id      = var.vpcid
  tags = {
    Name        = "${var.app}_${var.env}"
    source      = "terraform"
    project     = "API"
    environment = var.env
  }
  health_check {
    enabled             = true
    path                = "/"
    protocol            = "HTTP"
    matcher             = "403,302"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 60
    timeout             = 3
  }
}




resource "aws_lb_listener" "payment_http" {
  load_balancer_arn = aws_lb.payment_lb.arn
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



resource "aws_lb_listener" "payment_https" {
  load_balancer_arn = aws_lb.payment_lb.arn
  protocol          = "HTTPS"
  port              = "443"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.certpayment.arn

  default_action {
    type = "forward"
    forward {
      target_group {
        arn    = aws_lb_target_group.apple.arn
      }
      stickiness {
        enabled  = true
        duration = 3600
      }
    }
  }
}

resource "aws_autoscaling_attachment" "albapple" {
  autoscaling_group_name = var.autoscaling_group_apple
  alb_target_group_arn   = aws_lb_target_group.apple.arn
}


resource "aws_lb" "payment_lb" {
  name                       = "${var.env}-${var.app}"
  internal                   = false
  load_balancer_type         = "application"
  enable_deletion_protection = var.deletion_protection

  security_groups = [
    var.lbsc
  ]

  subnets = var.public_subnet
  tags = {
    name        = "${var.app}_lb"
    source      = "terrform"
    project     = "API"
    env         = var.env
  }
  lifecycle {
    create_before_destroy = true
  }
}
