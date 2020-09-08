variable "env" {
  type        = string
}

variable "vpcid" {
  type        = string
}

variable "app" {
  type        = string
}

variable "instance_type" {
  default = "t2.micro"
}
