terraform {
  required_version = ">= 0.12, < 0.13"
}

terraform {
  # Intentionally empty. Will be filled by Terragrunt.
  backend "s3" {}
}


module "rabbitmq" {
  source                            = "ulamlabs/rabbitmq/aws"
  version                           = "3.0.0"
  vpc_id                            = var.vpcid
  ssh_key_name                      = var.key_name
  subnet_ids                        = var.asgsc_application
  elb_additional_security_group_ids = var.rmqsg
  min_size                          = "2"
  max_size                          = "2"
  desired_size                      = "2"
}
