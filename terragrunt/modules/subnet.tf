terraform {
  # Intentionally empty. Will be filled by Terragrunt.
  backend "s3" {}
}

terraform {
  required_version = ">= 0.12, < 0.13"
}


resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpcid
  tags = {
    Name      = "api-${var.env}"
    terraform = "true"
    project   = "api"
    env       = var.env
  }
}

resource "aws_subnet" "public" {
  count                   = length(var.availability_zones)
  vpc_id                  = var.vpcid
  cidr_block              = cidrsubnet(var.cidr_block, 8, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "publicsubnet_${element(var.availability_zones, count.index)}"
    source = "terrform"
    project = "api"
    env = var.env
  }
}
resource "aws_subnet" "application" {
  count  = length(var.availability_zones)
  vpc_id = var.vpcid


  cidr_block              = cidrsubnet(var.cidr_block, 8, count.index + length(var.availability_zones))
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name = "applicationsubnet_${element(var.availability_zones, count.index)}"
    source = "terrform"
    project = "api"
    env = var.env
  }

}

resource "aws_eip" "nat" {
  count = length(var.availability_zones)
  vpc   = true
}
resource "aws_nat_gateway" "main" {
  count         = length(var.availability_zones)
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  allocation_id = element(aws_eip.nat.*.id, count.index)

  tags = {
    Name = "NAT_${element(var.availability_zones, count.index)}"
    source = "terrform"
    project = "api"
    env = var.env
  }
}
