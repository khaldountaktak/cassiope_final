data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "k8s_sg" {
  name        = "k8s_sg"
  description = "Allow SSH and Kubernetes API"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

ingress {
  description = "Calico BGP"
  from_port   = 179
  to_port     = 179
  protocol    = "tcp"
  cidr_blocks = ["172.31.0.0/16"]
}


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
