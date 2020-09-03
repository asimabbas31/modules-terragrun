terraform {
  required_version = ">= 0.12, < 0.13"
}

terraform {
  # Intentionally empty. Will be filled by Terragrunt.
  backend "s3" {}
}


# secrets management stuff
# credstash: https://github.com/fugue/credstash

resource "aws_kms_key" "credstash" {
  description             = "${var.app} ${var.env} credstash KMS master key"
  deletion_window_in_days = 30
  tags = {
    Name        = "${var.app}"
    source      = "terraform"
    project     = "api"
    environment = var.env
  }
}

resource "aws_kms_alias" "credstash" {
  name          = "alias/${var.app}_credstash_${var.env}"
  target_key_id = aws_kms_key.credstash.key_id
}

# construct the dynamodb database that credstash uses
# adopted from https://github.com/fugue/credstash/blob/4df7e2c832efe2b2bccdbc80be65923cccf6fd24/credstash.py
# L574+

resource "aws_dynamodb_table" "credstash" {
  name         = "${var.app}_${var.env}_credstash_store"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "name"
  range_key    = "version"

  attribute {
    name = "name"
    type = "S"
  }

  attribute {
    name = "version"
    type = "S"
  }

  # TODO: need to think about this because documentation says it takes up to 10
  # minutes to enable this. perhaps key it so production only?

  point_in_time_recovery {
    enabled = false
  }

  tags = {
    Name        = "credstash"
    source      = "terraform"
    project     = "api"
    environment = var.env
  }
}
