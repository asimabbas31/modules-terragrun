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
    app = var.app
    bucket_name = var.bucket_name
    env = var.env

      }
  }


resource "aws_launch_template" "payment" {
  name          = "${var.app}_${var.env}"
  image_id      = data.aws_ami.centos.id
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
    security_groups  = [var.sgapp]
  }

   iam_instance_profile {
    arn = var.instance_policy
  }  
  
  
  tag_specifications {
    resource_type = "instance"
    tags = {
      name        = "${var.app}"
      source      = "terraform"
      project     = "API"
      env         = var.env
    }
  }
  }
