
terraform {
  required_version = ">= 0.12"
}

terraform {
  # Intentionally empty. Will be filled by Terragrunt.
  backend "s3" {}
}

resource "aws_ecr_repository" "asim" {
  name                 = ${app}_${var.env}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
