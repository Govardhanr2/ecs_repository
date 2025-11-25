variable "aws_region" {
  description = "The AWS region."
  type        = string
}

variable "private_subnet_ids" {
  description = "The IDs of the private subnets."
  type        = list(string)
}

variable "ecs_service_sg_id" {
  description = "The ID of the ECS service security group."
  type        = string
}

variable "wordpress_tg_arn" {
  description = "The ARN of the WordPress target group."
  type        = string
}

variable "microservice_tg_arn" {
  description = "The ARN of the microservice target group."
  type        = string
}

variable "httpss_listener_arn" {
  description = "The ARN of the HTTPS listener, for dependency."
  type        = string
}

variable "db_address" {
  description = "The address of the RDS database."
  type        = string
}

variable "db_name" {
  description = "The name of the RDS database."
  type        = string
}

variable "db_credentials_secret_arn" {
  description = "The ARN of the secret containing the DB credentials."
  type        = string
}