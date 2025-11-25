# RDS DB Subnet Group
resource "aws_db_subnet_group" "default" {
  name       = "main-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "Main DB subnet group"
  }
}

# RDS Instance
resource "aws_db_instance" "default" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  db_name              = "wordpress"
  username             = var.db_username
  password             = var.db_password
  db_subnet_group_name = aws_db_subnet_group.default.name
  vpc_security_group_ids = [var.rds_sg_id]
  skip_final_snapshot  = true
  backup_retention_period = 0 # Disabled for AWS Free Tier compatibility

  tags = {
    Name = "wordpress-db"
  }
}