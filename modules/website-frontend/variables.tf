variable "domain_name" {
  description = "Domain name for the website"
  type        = string
}

variable "lambda_handler" {
  description = "Lambda handler"
  type        = string
  default     = "lambda_function.lambda_handler" # Match your actual handler
}

variable "s3_bucket_name" {
  description = "S3 bucket name"
  type        = string
}

variable "cloudfront_price_class" {
  description = "CloudFront price class"
  type        = string
  default     = "PriceClass_100"
}

variable "acm_validation_method" {
  description = "ACM certificate validation method"
  type        = string
  default     = "DNS"
}

variable "waf_enabled" {
  description = "Enable WAF for CloudFront"
  type        = bool
  default     = true
}

variable "waf_web_acl_name" {
  description = "WAF Web ACL name"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
