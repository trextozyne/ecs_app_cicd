
resource "aws_s3_bucket" "artifacts" {
  bucket        = "${var.codebuild_bucket}-codebuild-artifacts"
  force_destroy = true

  lifecycle {
    prevent_destroy = false
  }

  tags = var.common_tags
}

resource "aws_s3_bucket_public_access_block" "s3Public_artifacts" {
  bucket                  = aws_s3_bucket.artifacts.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}