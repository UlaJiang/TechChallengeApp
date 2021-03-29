provider "aws" {
  region = "ap-southeast-2"
}

resource "aws_launch_configuration" "techapp-launch-config" {
  image_id        = "ami-09a5d9ce3bcb72128"
  instance_type   = "t2.micro"
  security_groups = ["${aws_security_group.my-asg-sg.id}"]

  user_data = <<-EOF
#!/bin/bash
sudo service docker start
sudo docker pull ulajiang0419/servian_app:v1
sudo docker run  -d -p 80:3000 ulajiang0419/servian_app:v1
              EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "example" {
  launch_configuration = "${aws_launch_configuration.techapp-launch-config.name}"
  vpc_zone_identifier  = ["${var.subnet1}","${var.subnet2 }"]
  target_group_arns    = ["${var.target_group_arn}"]
  health_check_type    = "ELB"

  min_size = 2
  max_size = 10

  tag {
    key                 = "Name"
    value               = "techapp-asg"
    propagate_at_launch = true
  }
}

resource "aws_security_group" "my-asg-sg" {
  name   = "my-asg-sg"
  vpc_id = "${var.vpc_id}"
}

resource "aws_security_group_rule" "inbound_ssh" {
  from_port         = 22
  protocol          = "tcp"
  security_group_id = "${aws_security_group.my-asg-sg.id}"
  to_port           = 22
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "inbound_http" {
  from_port         = 80
  protocol          = "tcp"
  security_group_id = "${aws_security_group.my-asg-sg.id}"
  to_port           = 80
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "outbound_all" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = "${aws_security_group.my-asg-sg.id}"
  to_port           = 0
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
}