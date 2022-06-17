
terraform {
    source = "git::git@github.com:modules-terragrun//terragrunt/modules/mq"

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
  instance_type = "t3.medium"
  key_name = "pago"
  vpcid = dependency.vpc.outputs.vpcid
  public_subnet = dependency.subnets.outputs.subnet_public
  mquser ="sb-admin"
  mqpassword = "hpAFj5JNvMxz9JuApBUz"
  asg_aws_subnet_ids = dependency.subnets.outputs.asgsc_application
