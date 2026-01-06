terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Simple S3 bucket for practice (we'll extend this later)
resource "aws_s3_bucket" "ingestion" {
  bucket = var.bucket_name

  tags = {
    Name        = "${var.environment}-ingestion-bucket"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}
