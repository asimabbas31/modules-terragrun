terraform {

  source = "git::git@github.com:modules-terragrun/deployment-api//terragrunt/modules/autoscaling"
  
    extra_arguments "common_vars" {
    commands = get_terraform_commands_that_need_vars()

    arguments = [
      "-var-file=../../common.tfvars"
    ]
  }

}
include {
  path = find_in_parent_folders()
}

dependency "subnets" {
  config_path = "../network"
}

dependency "lt" {
  config_path = "../lunchtemplate"
}


inputs = {
  asg_aws_subnet_ids = dependency.subnets.outputs.asgsc_application
  lt_id              = dependency.lt.outputs.lt_id
}

dependencies {
  paths = [
    "../network"]
}
