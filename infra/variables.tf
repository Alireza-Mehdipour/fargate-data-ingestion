variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "ap-southeast-2"
}

variable "environment" {
  description = "Deployment environment (e.g., dev, prod)"
  type        = string
  default     = "dev"
}

variable "bucket_name" {
  description = "S3 bucket name for ingestion"
  type        = string
  default     = "fargate-ingestion-bucket-dev"
}
