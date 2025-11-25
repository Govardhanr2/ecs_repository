output "db_instance_address" {
  description = "The address of the RDS instance."
  value       = aws_db_instance.default.address
}

output "db_instance_name" {
  description = "The name of the RDS database."
  value       = aws_db_instance.default.db_name
}

output "db_credentials_secret_arn" {
  description = "The ARN of the secret containing the DB credentials."
  value       = aws_secretsmanager_secret.db_credentials.arn
}