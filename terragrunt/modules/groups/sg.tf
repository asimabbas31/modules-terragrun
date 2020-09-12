terraform {
  required_version = ">= 0.12"
}

terraform {
  # Intentionally empty. Will be filled by Terragrunt.
  backend "s3" {}
}

resource "aws_security_group" "sgapp" {
  name = "${var.app}-${var.env}"
  vpc_id = var.vpcid
  # Allow inbound HTTP requests
ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
  # Allow all outbound requests
egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
ingress {
    description = "API backend ssh port"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
tags = {
    Name = "${var.app}-api"
    env = var.env
    source = "terraform"
    project = "api"
}
  }


# external http/https specifically only allows access to janus
resource "aws_security_group" "loadbalancer_app" {
  name        = "${var.app}-lb-${var.env}"
  description = "loadbalancer policy"
  vpc_id      = var.vpcid

  ingress {
    description      = "global http"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }
  ingress {
    description      = "global https"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  egress {
    description = "open outbound access"
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.app}-lb"
    source      = "terraform"
    project     = "api"
    env         = var.env
  }
}


##For RMQ
resource "aws_security_group" "rmq" {
  name        = "rmq-${var.app}-${var.env}"
  description = "RMQ"
  vpc_id      = var.vpcid

  ingress {
    description      = "rmq"
    from_port        = 5672
    to_port          = 5672
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }
  
    ingress {
    protocol        = "tcp"
    from_port       = 15672
    to_port         = 15672
    cidr_blocks      = ["0.0.0.0/0"]
  }

    ingress {
    protocol        = "tcp"
    from_port       = 22
    to_port         = 22
    cidr_blocks      = ["0.0.0.0/0"]
  }


  # Allow all outbound requests
egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
  tags = {
    Name        = "rmq-${var.app}-${var.env}"
    source      = "terraform"
    project     = "api"
    env         = var.env
  }

  }

#For ELK
resource "aws_security_group" "elk" {
  name        = "elk-${var.app}-${var.env}"
  description = "ELK"
  vpc_id      = var.vpcid

  ingress {
    description      = "ELK"
    from_port        = 5601
    to_port          = 5601
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  # Allow all outbound requests
egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
  tags = {
    Name        = "elk-${var.app}-${var.env}"
    source      = "terraform"
    project     = "api"
    env         = var.env
  }

  }
