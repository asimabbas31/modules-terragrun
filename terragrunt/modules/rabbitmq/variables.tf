variable "env" {
  type        = string
}

variable "vpcid" {
  type        = string
}

variable "key_name" {
  type        = string
}


variable "asgsc_application" {
  description = "Subnets for RabbitMQ nodes"
  type        = list(string)
}
