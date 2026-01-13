output "private_subnets" {
  value = module.vpc.private_subnets
}

output "ec2_secgrp_id" {
  value = aws_security_group.ec2_secgrp.id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "my_vpc_id" {
  value = module.vpc.default_vpc_id
}
