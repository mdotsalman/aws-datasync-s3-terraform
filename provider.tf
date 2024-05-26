provider "aws" {
  region  = var.region
  profile = var.aws_profile
}

provider "aws" {
  region = var.region
  profile = "destination"
  alias = "destination"
}