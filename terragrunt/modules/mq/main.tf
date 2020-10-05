terraform {
  required_version = ">= 0.12"
}


terraform {
  # Intentionally empty. Will be filled by Terragrunt.
  backend "s3" {}
}

data "template_file" "backend_user_data" {
  template = file("./config_userdata.sh")
  

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
    security_groups  = [var.rmqsg]
  }
  
  
  tag_specifications {
    resource_type = "instance"
    tags = {
      name        = "${var.rabbitmq}"
      source      = "terraform"
      project     = "API"
      env         = var.env
    }
  }
  }
