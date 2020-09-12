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
  config_path = "../sc"
}

dependency "policy" {
  config_path = "../secrets"
}

inputs = {
  instance_type = "t2.micro"
  key_name = "pago"
  sgapp = dependency.groups.outputs.sgapp
  instance_policy   =  dependency.policy.outputs.instance_policy
  
}

dependencies {
  paths = [
    "../sc"
  ]
}
