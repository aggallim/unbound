provider "aws" {
  region     = "${var.region}"
}

data "aws_ami" "amzn-ami" {
  most_recent      = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn-ami*"]
  }
}

### CREATE SECURITY GROUPS ###
resource "aws_security_group" "unbound_sg1" {
  name = "unbound_sg1"
  description = "Unbound DNS"

  ingress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "unbound_sg1"
  }
}

### PREPARE BOOTSTRAP ###
data "template_file" "init" {
  template = "${file("${path.module}/install_unbound.sh")}"

  vars {
    vpc_dns = "${var.vpc_dns}"
    onprem_domain = "${var.onprem_domain}"
    onprem_dns  = "${var.onprem_dns}"
  }
}

### CREATE UNBOUND SERVER ###
resource "aws_instance" "unbound" {
  ami           = "${data.aws_ami.amzn-ami.id}"
  instance_type = "t2.micro"
  user_data     = "${data.template_file.init.rendered}"
}
