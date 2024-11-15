variable "region" {
  default = "us-west-1"
}

variable "ami" {
  default = "ami-0da424eb883458071"
}

variable "ssh_public_key_path" {
  default = "~/.ssh/id_rsa.pub"
}

variable "instance_type" {
  default = "t2.small"
}

variable "vpc_cidr_block" {
  default = "10.10.0.0/16"
}

variable "subnet_cidr_block" {
  default = "10.10.1.0/24"
}
