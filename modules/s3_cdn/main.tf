
/*provider "aws" {
  region = var.aws_region
}
*/

resource "aws_s3_bucket" "bucket" {
  bucket        = var.bucket_name
  force_destroy = true
  
}

resource "aws_s3_bucket_policy" "cdn-oac-bucket-policy" {
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.s3_bucket_policy.json

  depends_on = [aws_cloudfront_distribution.s3_distribution]
}

data "aws_iam_policy_document" "s3_bucket_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.bucket.arn}/*"]
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.s3_distribution.arn]
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "bucket_ownership_controls" {
  bucket = aws_s3_bucket.bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "access_block" {

  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

locals {
  s3_origin_id = "myS3Origin"
}

// Cloudfront Distribution
resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.bucket.bucket_regional_domain_name
    origin_id                = local.s3_origin_id
    origin_access_control_id = aws_cloudfront_origin_access_control.cloudfront_s3_oac.id
  }


  enabled             = true
  is_ipv6_enabled     = true
  comment             = var.bucket_name
  default_root_object = "index.html"

  # If there is a 404, return index.html with a HTTP 200 Response
  custom_error_response {
    error_caching_min_ttl = 3000
    error_code            = 404
    response_code         = 200
    response_page_path    = "/index.html"
  }

  custom_error_response {
    error_caching_min_ttl = 3000
    error_code            = 403
    response_code         = 200
    response_page_path    = "/index.html"
  }

  aliases = [var.sub-domain]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  ordered_cache_behavior {
    path_pattern     = "/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "DE", "IN"]
    }
  }

  viewer_certificate {
    acm_certificate_arn = data.aws_acm_certificate.cert.arn
    ssl_support_method  = "sni-only"
  }

}
resource "aws_cloudfront_origin_access_control" "cloudfront_s3_oac" {
  name                              = var.bucket_name
  description                       = var.bucket_name
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

// Certificate
data "aws_acm_certificate" "cert" {
  domain       = var.domain
 
  }

