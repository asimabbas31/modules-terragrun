terraform {

  source = "git::git@github.com:modules-terragrun//terragrunt/modules/loadbalancer"

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
dependency "groups" {
  config_path = "../groups"
}
dependency "vpc" {
  config_path = "../vpc"
}

dependency "autoscaling" {
  config_path = "../autoscaling"
}

inputs = {
  public_subnet = dependency.subnets.outputs.subnet_public
  lbsc = dependency.groups.outputs.lbsc
  vpcid = dependency.vpc.outputs.vpcid
  autoscaling_group_apple = dependency.autoscaling.outputs.autoscaling_group_apple
  domainname = "prod-apilatest.modules-terragrun.com"
}

dependencies {
  paths = [
    "../vpc",
    "../groups",
    "../network",
    "autoscaling"
    ]
}
