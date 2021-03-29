provider "aws" {
  region = "ap-southeast-2"
  access_key = var.access_key
  secret_key = var.secret_key
}

# VPC Creation
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "techapp-vpc"
  }
}

# Creating Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "techapp-igw"
  }
}

# Public Route Table
resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "techapp-public-route-table"
  }
}

# Private Route Table
resource "aws_default_route_table" "private_route" {
  default_route_table_id = aws_vpc.main.default_route_table_id

  tags = {
    Name = "techapp-private-route-table"
  }
}

# Public Subnet
resource "aws_subnet" "public_subnet" {
  cidr_block              = var.public_cidrs
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zones

  tags = {
    Name = "techapp-public-subnet"
  }
}

# Private Subnet
resource "aws_subnet" "private_subnet" {
  cidr_block        = var.private_cidrs
  vpc_id            = aws_vpc.main.id
  availability_zone = var.availability_zones

  tags = {
    Name = "techapp-private-subnet"
  }
}

# Associate Public Subnet with Public Route Table
resource "aws_route_table_association" "public_subnet_assoc" {
  route_table_id = aws_route_table.public_route.id
  subnet_id      = aws_subnet.public_subnet.id
  depends_on     = ["aws_route_table.public_route", "aws_subnet.public_subnet"]
}

# Associate Private Subnet with Private Route Table
resource "aws_route_table_association" "private_subnet_assoc" {
  route_table_id = aws_default_route_table.private_route.id
  subnet_id      = aws_subnet.private_subnet.id
  depends_on     = ["aws_default_route_table.private_route", "aws_subnet.private_subnet"]
}

# Security Group Creation
resource "aws_security_group" "test_sg" {
  name   = "techapp-sg"
  vpc_id = aws_vpc.main.id
}

# Ingress Security Port 22
resource "aws_security_group_rule" "ssh_inbound_access" {
  from_port         = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.test_sg.id
  to_port           = 22
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "http_inbound_access" {
  from_port         = 80
  protocol          = "tcp"
  security_group_id = "${aws_security_group.test_sg.id}"
  to_port           = 80
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "https_inbound_access" {
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.test_sg.id
  to_port           = 443
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

# All OutBound Access
resource "aws_security_group_rule" "all_outbound_access" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.test_sg.id
  to_port           = 0
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
}


# create an EC2
data "template_file" "init" {
  template = "${file("${path.module}/userdata.tpl")}"
}

resource "aws_key_pair" "techapp-key" {
  key_name   = "servian-app-key"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

resource "aws_instance" "techapp-instance" {
  ami                    = "ami-0eb614734861953fc"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.techapp-key.id
  vpc_security_group_ids = [aws_security_group.test_sg.id]
  subnet_id              = aws_subnet.public_subnet.id
  user_data              = "${data.template_file.init.rendered}"


  connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = "${file("~/.ssh/id_rsa")}"
    host = aws_instance.techapp-instance.public_ip
  }

  provisioner "file" {
    source      = "./docker-compose.yml"
    destination = "./docker-compose.yml"
  }

  tags = {
    Name = "techapp-instance"
  }
}