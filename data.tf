data "aws_caller_identity" "source" {
  
}
data "aws_caller_identity" "destination" {
  provider = aws.destination
}

data "aws_s3_bucket" "source_bucket" {
  bucket = var.source_bucket
}

data "aws_s3_bucket" "destination_bucket" {
  provider = aws.destination
  bucket   = var.destination_bucket
}