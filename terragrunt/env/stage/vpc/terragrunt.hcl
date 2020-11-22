 
terraform {

   source = "git::git@github.com:asimabbas31/wstest//terragrunt/modules/vpc"

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


inputs = {
  cidr_block = "10.18.0.0/16"
   }
