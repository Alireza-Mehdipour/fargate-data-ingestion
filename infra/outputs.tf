output "bucket_name" {
  description = "Name of the S3 bucket created"
  value       = aws_s3_bucket.ingestion.bucket
}

output "bucket_arn" {
  description = "ARN of the S3 bucket created"
  value       = aws_s3_bucket.ingestion.arn
}
