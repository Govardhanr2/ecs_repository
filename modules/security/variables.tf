variable "vpc_id" {
  description = "The ID of the VPC."
  type        = string
}

variable "github_org" {
  description = "The GitHub organization or username."
  type        = string
}

variable "github_repo" {
  description = "The name of the GitHub repository."
  type        = string
}

variable "aws_account_id" {
  description = "The AWS account ID."
  type        = string
}