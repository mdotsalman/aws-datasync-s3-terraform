resource "aws_cloudwatch_log_group" "datasync" {
  name = "datasync-s3-lg"

  tags = var.tags
}