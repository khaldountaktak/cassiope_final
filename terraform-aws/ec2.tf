data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}


resource "aws_instance" "control_plane" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.small"
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.k8s_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.control_plane_profile.name
  user_data                   = file("user_data/control-plane.sh")

  tags = {
    Name                          = "Control-plane"
    "kubernetes.io/cluster/${var.cluster_id}" = "owned"
  }
}

resource "aws_instance" "worker" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.small"
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.k8s_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.node_profile.name
  user_data                   = file("user_data/worker.sh")

  tags = {
    Name                          = "Node"
    "kubernetes.io/cluster/${var.cluster_id}" = "owned"
  }
}
