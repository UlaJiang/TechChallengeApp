variable "access_key" {
  description = "please input your access key"
  type = string
}

variable "secret_key" {
  description = "please input your secret key"
  type = string
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_cidrs" {
  default = "10.0.1.0/24"
}

variable "private_cidrs" {
  default = "10.0.3.0/24"
}

variable "availability_zones" {
  default = "ap-southeast-2a"
}
