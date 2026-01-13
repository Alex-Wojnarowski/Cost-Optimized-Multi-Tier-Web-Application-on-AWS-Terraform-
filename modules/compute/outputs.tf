output "ec2_role_arn_out" {
  value = aws_iam_role.ec2_s3_API_role.arn
}

output "ec2_dns_out" {
  value = aws_instance.web.public_dns
}
