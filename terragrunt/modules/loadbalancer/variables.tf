variable "env" {
  type        = string
}

variable "public_subnet" {
  type        = list
}

variable "lbsc" {
  type        = string
}

variable "vpcid" {
  type        = string
}

variable "app" {
  type        = string
}

variable "domainname" {
  type        = string
}

variable "deletion_protection" {
  description = "protect assets from accidental purging?"
  default     = false
}

variable "availability_zones" {
  type = list
}

variable "autoscaling_group_apple" {
  type = string
}

