terraform {
  required_version = ">= 0.12"
}


terraform {
  # Intentionally empty. Will be filled by Terragrunt.
  backend "s3" {}
}

data "template_file" "backend_user_data" {
  template = file("./config_userdata.sh")
  vars = {
  mqpassword = var.mqpassword
 mquser = var.mquser  
}
  }
resource "aws_launch_template" "rabbitmq" {
  name          = "${var.app}_${var.env}_rabbit_mq"
  image_id      = "ami-06fd8a495a537da8b"
  instance_type = var.instance_type
  key_name      = var.key_name

user_data = base64encode(data.template_file.backend_user_data.rendered)

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = 8
      delete_on_termination = true
    }
  }

  network_interfaces {
    description                 = "application private"
    device_index                = 0
    delete_on_termination       = true
    associate_public_ip_address = false
    security_groups  = [var.rmqsg.id]
  }
  
  
  tag_specifications {
    resource_type = "instance"
    tags = {
      name        = "RabbitMQ"
      source      = "terraform"
      project     = "API"
      env         = var.env
    }
  }
  }



resource "aws_autoscaling_group" "apple" {
  name = "${var.env}_apple_rmq"
  tags = [
    {
      key                 = "Name",
      value               = "RMQ"
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
    id      = aws_launch_template.rabbitmq.id
    version = "$Latest"
  }

  lifecycle {
    create_before_destroy = true
  
  }
}



