variable "aws_region" {
  type = string
  description = "provider region"
  default = "us-east-1"
}

variable "aws_instance_type" {
  type = string
  description= "instance type"
  default = "t2.micro"
}

# The values of these variables must be input at the time of build
#-------------------------------------------
variable "aws_ami" {
  type = string
  description = "ami instance"
}

variable "key_ssh" {
  type = string
  description = "ssh key of instances"
}
#-------------------------------------------

variable "aws_tags" {
  type = map(string)
  description = "instance tags"
  default = {
    Environmet = "testing terraform"
    Maintenance = "Vitor Santos"
    CreatedAt = "12/07/2021"
  }
}