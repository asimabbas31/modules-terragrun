include {
  path = find_in_parent_folders()
}



terraform {
    source = "git::git@github.com:modules-terragrun/deployment-api//terragrunt/modules/lunchtemplate"

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


dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
  instance_type = "t2.micro"
  key_name = "pago"
  rmqsg = dependency.groups.outputs.rmqsg
  vpcid = dependency.vpc.outputs.vpcid
  public_subnet = dependency.subnets.outputs.public_subnet
  mquser="tets"
  mqpassword= "test"
}
