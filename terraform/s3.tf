########################################
# Static files S3 bucket for Statuspage
########################################

resource "aws_s3_bucket" "statuspage_static" {
  bucket = "dr-statuspage-static-${var.env}"

  tags = {
    Name    = "dr-statuspage-static-${var.env}"
    Project = "dr_statuspage"
    OWNER   = "dr_admin"
    Env     = var.env
  }
}

# Website config (mainly for testing / direct access)
resource "aws_s3_bucket_website_configuration" "statuspage_static" {
  bucket = aws_s3_bucket.statuspage_static.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# Allow bucket-level public access
resource "aws_s3_bucket_public_access_block" "statuspage_static" {
  bucket = aws_s3_bucket.statuspage_static.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Allow public read to all objects inside bucket
resource "aws_s3_bucket_policy" "statuspage_static_policy" {
  bucket = aws_s3_bucket.statuspage_static.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowPublicRead"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.statuspage_static.arn}/*"
      }
    ]
  })
}

# ⚡ Account-level unblock (important if BlockPublicAccess is on globally)
resource "aws_s3_account_public_access_block" "this" {
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

