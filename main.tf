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

### CREATE UNBOUND SERVER ###
resource "aws_instance" "example" {
  ami           = "${lookup(var.amis, var.region)}"
  instance_type = "t2.micro"
}
