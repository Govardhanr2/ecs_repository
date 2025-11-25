variable "vpc_id" {
  description = "The ID of the VPC."
  type        = string
}

variable "public_subnet_ids" {
  description = "The IDs of the public subnets."
  type        = list(string)
}

variable "alb_sg_id" {
  description = "The ID of the ALB security group."
  type        = string
}

variable "domain_name" {
  description = "The domain name for the certificate and DNS records."
  type        = string
}