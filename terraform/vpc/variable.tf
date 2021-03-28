variable "access_key" {
  description = "please input your access key"
  type = string
}

variable "secret_key" {
  description = "please input your secret key"
  type = string
}

variable "vpc_cidr" {
}

variable "public_cidrs" {
  type = "list"
}

variable "private_cidrs" {
  type = "list"
}

variable "availability_zones" {
  type = "list"
}