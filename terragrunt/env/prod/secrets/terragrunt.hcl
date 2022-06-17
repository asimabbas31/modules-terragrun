terraform {

   source = "git::git@github.com:modules-terragrun//terragrunt/modules/secrets"

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
