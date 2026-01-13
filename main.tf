module "network" {
  source = "./modules/network"

  region      = var.region
  common_tags = local.tags_com
}

module "compute" {
  source = "./modules/compute"

  ami_id        = var.ami_id
  instance_type = var.instance_type
  az            = var.az
  subnet_id     = module.network.public_subnets[0]
  ec2_secgrp_id = module.network.ec2_secgrp_id
  depends_on    = [module.network]
  common_tags   = local.tags_com
}

module "storage" {
  source      = "./modules/storage"
  common_tags = local.tags_com
}
module "function" {
  source = "./modules/function"

  dynamodb_table_arn = module.storage.dynamodb_table_arn
  common_tags        = local.tags_com
}

