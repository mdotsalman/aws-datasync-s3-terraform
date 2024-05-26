terraform {

  backend "s3" {
    encrypt = true
    key     = "terraform.tfstate"
  }

  required_version = "~> 1.7.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.30"
    }
  }
}