output "bucket_id" {
  description = "El ID del bucket de S3"
  value       = aws_s3_bucket.s3_bucket.id
}

