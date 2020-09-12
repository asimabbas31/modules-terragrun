terraform {
  required_version = ">= 0.12"
}

terraform {
  # Intentionally empty. Will be filled by Terragrunt.
  backend "s3" {}
}


resource "aws_autoscaling_group" "apple" {
  name = "${var.env}_apple_${var.app}"
  tags = [
    {
      key                 = "Name",
      value               = "${var.app}"
      propagate_at_launch = true
    },
    {
      key                 = "source",
      value               = "terraform"
      propagate_at_launch = true
    },
    {
      key                 = "project",
      value               = "API"
      propagate_at_launch = true
    },
    {
      key                 = "env",
      value               = var.env
      propagate_at_launch = true
    },
  ]

  min_size            = "1"
  max_size            = "1"
  desired_capacity    = "1"

  health_check_type   = "ELB"
  vpc_zone_identifier = var.asg_aws_subnet_ids
  launch_template {
    id      = var.lt_id
    version = "$Latest"
  }

  lifecycle {
    create_before_destroy = true
  
  }
}
