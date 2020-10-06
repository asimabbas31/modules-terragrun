variable "instance_type" {
  description = "API Instances for app"
}

variable "key_name" {
  type        = string
 }


variable "env" {
  type        = string
}

variable "rmqsg" {
  type        = string
}

variable "app" {
  type        = string
}

variable "vpcid" {
  type        = string
}

variable "public_subnet" {
  type = list(string)
}


variable "asgsc_application" {
  type = list(string)
}
