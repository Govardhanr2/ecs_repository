variable "private_subnet_ids" {
  description = "The IDs of the private subnets."
  type        = list(string)
}

variable "rds_sg_id" {
  description = "The ID of the RDS security group."
  type        = string
}

variable "db_username" {
  description = "The username for the database."
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "The password for the database."
  type        = string
  sensitive   = true
}