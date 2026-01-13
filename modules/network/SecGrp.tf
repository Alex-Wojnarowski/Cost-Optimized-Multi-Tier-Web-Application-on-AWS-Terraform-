#Security group EC2
resource "aws_security_group" "ec2_secgrp" {
  name   = "EC2_Terra_Subnet"
  vpc_id = module.vpc.vpc_id

  tags = var.common_tags
}

#Rule to allow ssm and nat communication
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.ec2_secgrp.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

#Security group VPC Endpoints
resource "aws_security_group" "endpoint_secgrp" {
  name   = "VPC_Endpoint_SG"
  vpc_id = module.vpc.vpc_id

  tags = var.common_tags
}

resource "aws_vpc_security_group_ingress_rule" "allow_https_ssm" {
  security_group_id            = aws_security_group.endpoint_secgrp.id
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.ec2_secgrp.id
}
