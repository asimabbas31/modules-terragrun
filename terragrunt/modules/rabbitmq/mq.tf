terraform {
  required_version = ">= 0.12"
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
  subnet_ids                        = var.subnet_public
  instance_type                     = var.instance_type
  elb_additional_security_group_ids = var.cluster_security_group_id
  min_size                          = "2"
  max_size                          = "2"
  desired_size                      = "2"
}
