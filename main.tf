import {
  to = aws_s3_bucket.this
  id = "elastic-purple-website-s3-bucket"
}


resource "aws_s3_bucket" "this" {
  bucket = "elastic-purple-website-s3-bucket"
}


resource "aws_route53_record" "this" {
  zone_id = "Z015596023ZJ41YNGKLQF"
  name    = "elasticpurple.com"
  type    = "A"

  alias {
    name                   = "d1vyjf65raehbn.cloudfront.net."
    zone_id                = "Z015596023ZJ41YNGKLQF"
    evaluate_target_health = false
  }
}


resource "aws_cloudfront_distribution" "this" {
  enabled = true

  origin {
    domain_name = "example.com"
    origin_id   = "origin-1"
  }

  default_cache_behavior {
    target_origin_id       = "origin-1"
    viewer_protocol_policy = "allow-all"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

resource "aws_dynamodb_table" "this" {
  name = "cloudresume"
}

resource "aws_acm_certificate" "this" {
  domain_name       = "elasticpurple.com"
  validation_method = "DNS"
}

resource "aws_lambda_function" "this" {
  function_name = "cloudresume-counter-api"

  # Temporary placeholders to satisfy validation
  role    = "arn:aws:iam::000000000000:role/placeholder"
  handler = "index.handler"
  runtime = "nodejs18.x"
}
