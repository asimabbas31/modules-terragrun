include {
  path = find_in_parent_folders()
}



terraform {
    source = "git::git@github.com:modules-terragrun//terragrunt/modules/rabbitmq"
  
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
dependency "network" {
  config_path = "../network"
}

inputs = {
  vpcid = dependency.vpc.outputs.vpcid
  key_name= "pago"
  asgsc_application= dependency.network.outputs.asgsc_application
  public_subnet = dependency.network.outputs.subnet_public
    
}

dependencies {
  paths = [
    "../vpc",
    ]
}
