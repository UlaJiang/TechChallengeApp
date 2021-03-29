provider "aws" {
  region = "ap-southeast-2"
}

module "vpc" {
  source          = "./vpc"
  vpc_cidr        = "10.0.0.0/16"
  public_cidrs    = ["10.0.1.0/24", "10.0.2.0/24"]
  private_cidrs   = ["10.0.3.0/24", "10.0.4.0/24"]
  availability_zones = ["ap-southeast-2a", "ap-southeast-2b"]
}

module "ec2" {
  source         = "./ec2"
  my_public_key  = "~/.ssh/id_rsa.pub"
  security_group = "${module.vpc.security_group}"
  subnets        = "${module.vpc.public_subnets}"
}

module "alb" {
  source = "./alb"
  vpc_id = "${module.vpc.vpc_id}"
  instance1_id = "${module.ec2.instance1_id}"
  instance2_id = "${module.ec2.instance2_id}"
  subnet1 = "${module.vpc.subnet1}"
  subnet2 = "${module.vpc.subnet2}"
}

# module "auto_scaling" {
#   source           = "./auto_scaling"
#   vpc_id           = "${module.vpc.vpc_id}"
#   subnet1          = "${module.vpc.subnet1}"
#   subnet2          = "${module.vpc.subnet2}"
#   target_group_arn = "${module.alb.alb_target_group_arn}"
# }

module "postgres" {
  source      = "./postgres"
  rds_subnet1 = "${module.vpc.private_subnet1}"
  rds_subnet2 = "${module.vpc.private_subnet2}"
  vpc_id      = "${module.vpc.vpc_id}"
}

# output "alb-dns" {
#   value = "${module.ald.alb_dns_name}"
# }

