# DataSync Source Location
resource "aws_datasync_location_s3" "source" {
  s3_bucket_arn = data.aws_s3_bucket.source_bucket.arn
  subdirectory  = var.source_directory

  s3_config {
    bucket_access_role_arn = aws_iam_role.datasync_src.arn
  }

  tags = var.tags
}

# DataSync Destination Location
resource "aws_datasync_location_s3" "destination" {
  s3_bucket_arn = data.aws_s3_bucket.destination_bucket.arn
  subdirectory  = var.destination_directory

  s3_config {
    bucket_access_role_arn = aws_iam_role.datasync_dest.arn
  }

  tags = var.tags
}

# DataSync Task
resource "aws_datasync_task" "s3_bucket" {
  destination_location_arn = aws_datasync_location_s3.destination.arn
  name                     = var.source_bucket
  source_location_arn      = aws_datasync_location_s3.source.arn
  cloudwatch_log_group_arn = aws_cloudwatch_log_group.datasync.arn

  options {
    atime             = "BEST_EFFORT"
    posix_permissions = "NONE"
    uid               = "NONE"
    gid               = "NONE"
    bytes_per_second  = -1
    log_level         = "BASIC"
  }

  tags = var.tags
}