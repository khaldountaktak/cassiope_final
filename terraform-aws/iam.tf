resource "aws_iam_policy" "control_plane_policy" {
  name   = "control-plane-policy"
  policy = file("control-plane-policy.json")
}

resource "aws_iam_policy" "node_policy" {
  name   = "node-policy"
  policy = file("node-policy.json")
}

resource "aws_iam_role" "control_plane_role" {
  name = "ControlPlaneRole"
  assume_role_policy = file("trust-policy.json")
}

resource "aws_iam_role" "node_role" {
  name = "NodeRole"
  assume_role_policy = file("trust-policy.json")
}

resource "aws_iam_role_policy_attachment" "control_plane_attach" {
  role       = aws_iam_role.control_plane_role.name
  policy_arn = aws_iam_policy.control_plane_policy.arn
}

resource "aws_iam_role_policy_attachment" "node_attach" {
  role       = aws_iam_role.node_role.name
  policy_arn = aws_iam_policy.node_policy.arn
}

resource "aws_iam_instance_profile" "control_plane_profile" {
  name = aws_iam_role.control_plane_role.name
  role = aws_iam_role.control_plane_role.name
}

resource "aws_iam_instance_profile" "node_profile" {
  name = aws_iam_role.node_role.name
  role = aws_iam_role.node_role.name
}
