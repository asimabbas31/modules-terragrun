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

variable "elb_additional_security_group_ids" {
  type    = list(string)
  default = []
}

variable "" {
  type    = list(string)
  default = []
}
