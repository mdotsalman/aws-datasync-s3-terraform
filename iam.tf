# DataSync Destination Location IAM
resource "aws_iam_role" "datasync_dest" {

  name = "IAM-RL-DataSync-S3"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "datasync.amazonaws.com"
        }
      },
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "datasync" {
  role       = aws_iam_role.datasync_dest.name
  policy_arn = "arn:aws:iam::aws:policy/AWSDataSyncFullAccess"
}

resource "aws_iam_role_policy_attachment" "datasync_ro" {
  role       = aws_iam_role.datasync_dest.name
  policy_arn = "arn:aws:iam::aws:policy/AWSDataSyncReadOnlyAccess"
}

data "aws_iam_policy_document" "datasync_custom_policy" {
  statement {
    sid    = "S3Access"
    effect = "Allow"
    resources = [
      "${data.aws_s3_bucket.destination_bucket.arn}"
    ]
    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads"
    ]
  }
  statement {
    sid    = "S3UploadAccess"
    effect = "Allow"
    resources = [
      "${data.aws_s3_bucket.destination_bucket.arn}/*"
    ]
    actions = [
      "s3:AbortMultipartUpload",
      "s3:DeleteObject",
      "s3:GetObject",
      "s3:ListMultipartUploadParts",
      "s3:PutObject",
      "s3:GetObjectTagging",
      "s3:PutObjectTagging"
    ]
  }
  statement {
    sid    = "CloudWatchAccess"
    effect = "Allow"
    resources = [
      "arn:aws:logs:${var.region}:${data.aws_caller_identity.source.account_id}:log-group:*:*"
    ]
    actions = [
      "logs:PutLogEvents",
      "logs:CreateLogStream"
    ]
  }
}

resource "aws_iam_policy" "datasync_custom_policy" {
  name   = "IAM-PL-DataSync-S3"
  policy = data.aws_iam_policy_document.datasync_custom_policy.json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "datasync_custom_policy" {
  role       = aws_iam_role.datasync_dest.name
  policy_arn = aws_iam_policy.datasync_custom_policy.arn
}


# DataSync Source Location IAM

resource "aws_iam_role" "datasync_src" {
  name = "IAM-RL-DataSync-SRC-S3"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Sid" : "AllowAWSDataSync"
        Effect = "Allow"
        Principal = {
          Service = "datasync.amazonaws.com"
        }
        Action = "sts:AssumeRole"
        "Condition" : {
          "StringEquals" : {
            "aws:SourceAccount" : "${data.aws_caller_identity.source.account_id}"
          },
          "ArnLike" : {
            "aws:SourceArn" : "arn:aws:datasync:${var.region}:${data.aws_caller_identity.source.account_id}:*"
          }
        }
      }
    ]
  })

  tags = var.tags
}

data "aws_iam_policy_document" "datasync_src_custom_policy" {
  statement {
    sid    = "AWSDataSyncS3BucketPermissions"
    effect = "Allow"
    resources = [
      "${data.aws_s3_bucket.source_bucket.arn}"
    ]
    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads"
    ]

  }
  statement {
    sid    = "AWSDataSyncS3ObjectPermissions"
    effect = "Allow"
    resources = [
      "${data.aws_s3_bucket.source_bucket.arn}/*"
    ]
    actions = [
      "s3:AbortMultipartUpload",
      "s3:DeleteObject",
      "s3:GetObject",
      "s3:GetObjectTagging",
      "s3:GetObjectVersion",
      "s3:GetObjectVersionTagging",
      "s3:ListMultipartUploadParts",
      "s3:PutObject",
      "s3:PutObjectTagging"
    ]
  }
  statement {
    sid    = "CloudWatchAccess"
    effect = "Allow"
    resources = [
      "arn:aws:logs:${var.region}:${data.aws_caller_identity.source.account_id}:log-group:*:*"
    ]
    actions = [
      "logs:PutLogEvents",
      "logs:CreateLogStream"
    ]
  }
}

resource "aws_iam_policy" "datasync_src_custom_policy" {
  name   = "IAM-PL-DataSync-SRC-S3"
  policy = data.aws_iam_policy_document.datasync_src_custom_policy.json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "datasync_src_custom_policy" {
  role       = aws_iam_role.datasync_src.name
  policy_arn = aws_iam_policy.datasync_src_custom_policy.arn
}