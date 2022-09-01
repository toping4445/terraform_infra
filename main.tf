provider "aws" {
  region  = "ap-northeast-2"
  profile = "dev"
}

terraform {
  required_version = "~> 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.18.0"
    }    
  }

  backend "s3" {
    encrypt = true
    bucket  = "pay-mlops-terraform"
    key     = "terraform.tfstate"
    region  = "ap-northeast-2"
    profile = "dev"
  }
}

locals {
  config = yamldecode(file(var.config_file))
}
