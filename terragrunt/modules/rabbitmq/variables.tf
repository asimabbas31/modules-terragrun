variable "env" {
  type        = string
}

variable "vpcid" {
  type        = string
}

variable "app" {
  type        = string
}

variable "key_name" {
  type        = string
}

variable "instance_type" {
  default = "t2.micro"
}

variable "cluster_security_group_id" {
  type    = list(string)
  default = []
}

variable "subnet_public" {
  type    = list(string)
  default = []
}
