resource "aws_instance" "web" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  availability_zone           = var.az
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.ec2_secgrp_id]
  associate_public_ip_address = true

  user_data = file("${path.module}/ssminstall.sh")

  tags        = var.common_tags
  volume_tags = var.common_tags
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com", "ssm.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ec2_s3_API_role" {
  name               = "Terraform-ec2-s3-API-access-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json

  tags = var.common_tags
}

resource "aws_iam_role_policy_attachment" "API_access" {
  role       = aws_iam_role.ec2_s3_API_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonAPIGatewayInvokeFullAccess"
}

resource "aws_iam_role_policy_attachment" "S3_access" {
  role       = aws_iam_role.ec2_s3_API_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-s3-api-access-profile"
  role = aws_iam_role.ec2_s3_API_role.name
}

#SSM Role
resource "aws_iam_role_policy_attachment" "ssm_attach" {
  role       = aws_iam_role.ec2_s3_API_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
