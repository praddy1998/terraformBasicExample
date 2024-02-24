resource "aws_s3_bucket" "bucket" {
  force_destroy = true
  for_each = toset(var.bucket_name)
  bucket               = "${each.key}"
}

resource "aws_s3_bucket_policy" "bucket_policy" {
    for_each = toset(var.bucket_name)
    bucket = "${aws_s3_bucket.bucket[each.key].id}"
    policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Principal = "*"
        Action = [
          "*",
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:s3:::${each.key}",
          "arn:aws:s3:::${each.key}/*"
        ]
      },
      {
        Sid = "PublicReadGetObject"
        Principal = "*"
        Action = [
          "s3:GetObject",
        ]
        Effect   = "Allow"
        Resource = [
          "arn:aws:s3:::${each.key}",
          "arn:aws:s3:::${each.key}/*"
        ]
      },
    ]
  })
  
  depends_on = [aws_s3_bucket_public_access_block.access_block]
}

resource "aws_s3_bucket_public_access_block" "access_block" {
  for_each = toset(var.bucket_name)
  bucket = "${aws_s3_bucket.bucket[each.key].id}"

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_cors_configuration" "cors_config" {
  for_each = toset(var.bucket_name)
  bucket = "${aws_s3_bucket.bucket[each.key].id}"

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT",
            "POST",
            "DELETE",
            "HEAD",
            "GET" ]
    allowed_origins = ["*"]
    /*expose_headers  = ["ETag"]*/
    max_age_seconds = 3000
  }
}

/*
resource "aws_s3_bucket_acl" "bucket" {
  bucket = "${aws_s3_bucket.bucket.id}"
  acl    = "public-read"
}*/

resource "aws_s3_bucket_website_configuration" "website_config" {
  for_each = toset(var.bucket_name)
  bucket = "${aws_s3_bucket.bucket[each.key].id}"

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }

}