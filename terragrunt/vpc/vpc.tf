terraform {
  required_version = ">= 0.12, < 0.13"
}

terraform {
  # Intentionally empty. Will be filled by Terragrunt.
  backend "s3" {}
}


resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags =  {
    Name = "${var.app}-${var.env}"
    source = "terraform"
    project = "api"
    env = var.env 
}
  }
