output "website_url" {
  description = "Website URL"
  value       = "https://${var.domain_name}"
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID"
  value       = module.website_frontend.cloudfront_distribution_id
}

output "s3_bucket_name" {
  description = "S3 bucket name"
  value       = module.website_frontend.s3_bucket_name
}

output "lambda_function_url" {
  description = "Lambda function URL"
  value       = module.visitor_counter.function_url
}

output "route53_name_servers" {
  description = "Route53 name servers"
  value       = module.website_frontend.route53_name_servers
}
