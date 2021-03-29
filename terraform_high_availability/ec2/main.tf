provider "aws" {
  region = "ap-southeast-2"
}

data "template_file" "init" {
  template = "${file("${path.module}/userdata.tpl")}"
}

resource "aws_key_pair" "techapp-key" {
  key_name   = "techapp_servian-key"
  public_key = "${file(var.my_public_key)}"
}

resource "aws_instance" "techapp-instance" {
  count                  = 2
  ami                    = "ami-09a5d9ce3bcb72128"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.techapp-key.id
  vpc_security_group_ids = ["${var.security_group}"]
  subnet_id              = "${element(var.subnets, count.index )}"
  user_data              = "${data.template_file.init.rendered}"

  tags = {
    Name = "techapp-instance-${count.index + 1}"
  }
}