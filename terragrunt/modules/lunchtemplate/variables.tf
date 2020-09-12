variable "instance_type" {
  description = "API Instances for app"
}

variable "key_name" {
  type        = string
 }


variable "env" {
  type        = string
}

variable "sgapp" {
  type        = string
}

variable "app" {
  type        = string
}


 data "aws_ami" "api" {
   most_recent = true
   filter {
     name   = "name"
     values = ["ami-latest"]
   }
   owners = ["957382640169"]
 }
variable "instance_policy" {
  type        = string
}

