
# IAM policy and bucket policy are *distinct*
# NOTE: READ ONLY ACCESS - the backend instances do not need anything else

data "aws_iam_policy_document" "payment" {
  version = "2012-10-17"
  statement {
    actions = [
      "ec2:DescribeInstances",
      "ec2:describetags"
    ]
    resources = [
      "*"
    ]
    effect = "Allow"
  }
  statement {
    actions = [
      "kms:Decrypt"
    ]
    resources = [
      aws_kms_key.credstash.arn
    ]
    effect = "Allow"
  }
  
  statement {
    actions = [
      "SecretsManagerReadWrite:*",
      "Secretsmanager:GetSecretValue"
    ]
    resources = [
      "*"
    ]
    effect = "Allow"
  }
  statement {

    actions = [
      "dynamodb:GetItem",
      "dynamodb:Query",
      "dynamodb:Scan"
    ]
    resources = [
      aws_dynamodb_table.credstash.arn
    ]
    effect = "Allow"
  }
  
  statement {
    actions = [
      "s3:*"
    ]
    resources = [
      "*"
    ]
    effect = "Allow"
  }
  
  }
 
resource "aws_iam_policy" "payment" {
  name   = "${var.app}_${var.env}"
  path   = "/${var.app}/${var.env}/"
  policy = data.aws_iam_policy_document.payment.json
}

data "aws_iam_policy_document" "payment_backend" {
   statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    effect = "Allow"
  }


}

resource "aws_iam_role" "payment_backend" {

  path               = "/"
  name               = "${var.app}_${var.env}"
  description        = " backend EC2 instance access in ${var.env} environment"
  assume_role_policy = data.aws_iam_policy_document.payment_backend.json
  tags = {
    Name        = "payment backend"
    terraform   = "true"
    project     = "api"
    env         = var.env
  }
}

resource "aws_iam_role_policy_attachment" "payment" {
  role       = aws_iam_role.payment_backend.name
  policy_arn = aws_iam_policy.payment.arn
}

resource "aws_iam_instance_profile" "payment_backend" {

  name = "${var.app}_backend_${var.env}"
  role = aws_iam_role.payment_backend.name
}
  
