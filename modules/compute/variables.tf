variable "instance_type" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "az" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "ec2_secgrp_id" {
  type = string
}

variable "common_tags" {
  type = map(string)
}
