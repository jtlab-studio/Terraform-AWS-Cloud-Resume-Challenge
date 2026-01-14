

module "visitor_counter" {
  source = "./modules/visitor-counter"

  function_name        = "cloudresume-counter-api"
  lambda_role_name     = var.lambda_role_name
  lambda_role_path     = "/service-role/"
  dynamodb_table_name  = "cloudresume"
  lambda_runtime       = var.lambda_runtime
  lambda_handler       = var.lambda_handler
  log_retention_days   = var.cloudwatch_log_retention_days
  cors_allowed_origins = ["https://${var.domain_name}", "https://www.${var.domain_name}"]

  tags = var.default_tags
}

module "website_frontend" {
  source = "./modules/website-frontend"

  providers = {
    aws           = aws
    aws.us_east_1 = aws.us_east_1
  }

  domain_name            = var.domain_name
  s3_bucket_name         = var.s3_bucket_name
  cloudfront_price_class = "PriceClass_100"
  acm_validation_method  = "DNS"
  waf_enabled            = true
  waf_web_acl_name       = var.waf_web_acl_name

  tags = var.default_tags
}
