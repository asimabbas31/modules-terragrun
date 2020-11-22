locals {
  
  # Automatically load region-level/application variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  application_name = read_terragrunt_config(find_in_parent_folders("application.hcl"))


  # Extract the variables we need for easy access
  aws_region   = local.region_vars.locals.aws_region
  application = local.application_name.locals.application
}

# Generate an AWS provider block
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.aws_region}"
  version = "~> 2.49"
  profile = "default"
  }
EOF
}


remote_state {
  backend = "s3"
  config = {
    bucket = "cars-pak"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region = "${local.aws_region}"
    encrypt        = true
    dynamodb_table = "cars-pak"
}
  }
