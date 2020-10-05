include {
  path = find_in_parent_folders()
}



terraform {
    source = "git::git@github.com:SafeBoda/deployment-api//terragrunt/modules/lunchtemplate"

    extra_arguments "common_vars" {
    commands = get_terraform_commands_that_need_vars()

    arguments = [
      "-var-file=../../common.tfvars"
    ]
  }

}



dependency "groups" {
  config_path = "../groups"
}

dependency "subnets" {
  config_path = "../network"
}

inputs = {
  instance_type = "t3.medium"
  key_name = "pago"
  rmqsg = dependency.groups.outputs.rmqsg
  asg_aws_subnet_ids = dependency.subnets.outputs.asgsc_application
}
