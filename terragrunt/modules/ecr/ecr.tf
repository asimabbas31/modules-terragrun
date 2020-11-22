resource "aws_ecr_repository" "asim" {
  name                 = ${app}_${var.env}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
