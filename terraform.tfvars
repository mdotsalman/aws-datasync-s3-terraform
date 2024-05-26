region            = "eu-central-1"
current_workspace = "datasync"
product           = "product-name"
account_name      = "account-alias"
aws_profile       = "account-alias"

source_bucket    = "source-bucket-name"
source_directory = "/"

destination_bucket    = "destination-bucket-name"
destination_directory = "/"

tags = {
  "Environment" = "Production"
  "Function"    = "S3 Transfer"
  "Region"      = "eu-central-1"
  "Service"     = "AWS DataSync"
}