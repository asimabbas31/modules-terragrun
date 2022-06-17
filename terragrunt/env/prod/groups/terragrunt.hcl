include {
  path = find_in_parent_folders()
}
terraform {
    source = "git::git@github.com:modules-terragrun/deployment-api//terragrunt/modules/groups"
     extra_arguments "common_vars" {
    commands = get_terraform_commands_that_need_vars()
    arguments = [
      "-var-file=../../common.tfvars"
    ]
  } 
}


 dependency "vpc" {
  config_path = "../vpc"
}


inputs = {
  vpcid = dependency.vpc.outputs.vpcid
}


dependencies {
  paths = [
    "../vpc"]
}
