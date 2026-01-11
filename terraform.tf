terraform {
  required_version = "~> 1.14.0"

  backend "s3" {
    bucket       = "crc-terraform-state-11012026"
    key          = "crc/terraform.tfstate"
    region       = "eu-central-1"
    encrypt      = true
    use_lockfile = true # S3 native locking since DynamoDB state-locking has been deprecated
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Default provider (Frankfurt)
provider "aws" {
  region = "eu-central-1"
}

# ACM + CloudFront provider (required region)
provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}
