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


variable "asg_aws_subnet_ids" {
  type = list(string)
}

variable "mquser" {
  type = list(string)
}
variable "mqpassword" {
  type = list(string)
}
