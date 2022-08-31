provider "aws" {
  region  = "ap-northeast-2"
  profile = "aws-dna"
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
    bucket  = "dna-4th-team3-iac-aws-cloud"
    key     = "demo/terraform.tfstate"
    region  = "ap-northeast-2"
    profile = "aws-dna"
  }
}

locals {
  config = yamldecode(file(var.config_file))
}
