data "aws_iam_policy_document" "server_agent" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "server_agent" {
  name = "server-agent"

  assume_role_policy = data.aws_iam_policy_document.server_agent.json
}

resource "aws_iam_role_policy_attachment" "server_agent" {
  role = aws_iam_role.server_agent.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "server_profile" {
  name = "server-agent"

  role = aws_iam_role.server_agent.name
}

resource "aws_security_group" "server_sg" {
  vpc_id = var.vpc

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
