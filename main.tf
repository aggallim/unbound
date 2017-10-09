provider "aws" {
  region     = "${var.region}"
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
    consul_address = "${aws_instance.consul.private_ip}"
    vpc_dns =
    onprem_domain =
    onprem_dns  =
  }
}

### CREATE UNBOUND SERVER ###
resource "aws_instance" "example" {
  ami           = "${lookup(var.amis, var.region)}"
  instance_type = "t2.micro"
}
