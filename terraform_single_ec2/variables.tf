variable "access_key" {
  # description = "please input your access key"
  default = "AKIAQHQSEA57SRPODS4B"
  # type = string
}

variable "secret_key" {
  # description = "please input your secret key"
  # type = string
  default = "YhTehbcqC4xlYHhs+/D8g+8E0Z53JbbY6BpNGtKV"
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

# variable "my_public_key" {
#   default = "~/.ssh/id_rsa.pub"
# }
