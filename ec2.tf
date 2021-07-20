resource "aws_key_pair" "key" {
  key_name = "key_ssh"
  public_key = var.key_ssh
}

resource "aws_security_group" "this" {
  ingress {
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "ssh"
    from_port = 22
    protocol = "tcp"
    to_port = 22
  } 

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    self = true
  }

  ingress  {
    cidr_blocks = ["0.0.0.0/0"]
    description = "icmp/ping"
    from_port = -1
    to_port = -1
    protocol = "icmp"
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "this" {
  count = 3
  ami = var.aws_ami
  instance_type = var.aws_instance_type
  key_name = "key_ssh"

  tags = var.aws_tags

  security_groups = [ "${aws_security_group.this.name}" ]
}