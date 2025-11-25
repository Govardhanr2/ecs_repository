# Add a random suffix to the secret name to avoid conflicts
resource "random_string" "secret_suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "aws_secretsmanager_secret" "db_credentials" {
  name = "rds-db-credentials-${random_string.secret_suffix.result}"
}

resource "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = var.db_username
    password = var.db_password
    host     = aws_db_instance.default.address
    dbname   = aws_db_instance.default.db_name
  })
}