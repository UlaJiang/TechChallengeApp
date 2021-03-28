variable "access_key" {
  description = "please input your access key"
  type = string
}

variable "secret_key" {
  description = "please input your secret key"
  type = string
}


variable "my_public_key" {
  default = "~/.ssh/id_rsa.pub"
}

variable "security_group" {}

variable "subnets" {
  type = "list"
}