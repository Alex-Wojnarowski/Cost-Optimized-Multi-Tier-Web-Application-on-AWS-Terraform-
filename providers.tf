terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.28.0"
    }
  }
}

provider "aws" {
  region = var.region
}


terraform {
  backend "s3" {
    bucket       = "terra-rmt-bkd-aw"
    key          = "env/dev/terraform.tfstate"
    region       = "eu-central-1"
    use_lockfile = true
  }
}
