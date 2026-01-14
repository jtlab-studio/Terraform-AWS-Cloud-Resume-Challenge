variable "primary_region" {
  description = "Primary AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "domain_name" {
  description = "Domain name for the website"
  type        = string
}

variable "s3_bucket_name" {
  description = "S3 bucket name for website hosting"
  type        = string
}

variable "default_tags" {
  description = "Default tags to apply to all resources"
  type        = map(string)
  default = {
    Project   = "Cloud Resume Challenge"
    ManagedBy = "Terraform"
    Name      = "ElasticPurple"
  }
}

variable "cloudwatch_log_retention_days" {
  description = "CloudWatch log retention in days"
  type        = number
  default     = 14
}

variable "lambda_runtime" {
  description = "Lambda runtime"
  type        = string
  default     = "python3.11"
}

variable "lambda_handler" {
  description = "Lambda handler"
  type        = string
  default     = "index.handler"
}

variable "lambda_role_name" {
  description = "Lambda execution role name"
  type        = string
}

variable "waf_web_acl_name" {
  description = "WAF Web ACL name"
  type        = string
}
