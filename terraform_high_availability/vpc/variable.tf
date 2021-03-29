variable "access_key" {
  # description = "please input your access key"
  default = "AKIA2VBI4BTNPALKREHT"
  # type = string
}

variable "secret_key" {
  # description = "please input your secret key"
  # type = string
  default = "xbl/q1Zx+6V4f4HEUEK2/QFz3lF5XJKg0bmjB8TY"
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