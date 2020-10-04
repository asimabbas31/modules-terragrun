variable "vpcid" {
}

variable "key_name" {
}

variable "env" {
}


variable "app" {
}



variable "asgsc_application" {
  type        = list
}

variable "public_subnet" {
  type        = list
}


variable "rmqsg" {
  default     = "sg-07dda92883c803056"
  }
