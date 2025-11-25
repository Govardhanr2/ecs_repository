output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer."
  value       = module.alb.lb_dns_name
}

output "microservice_ecr_repository_url" {
  description = "The URL of the ECR repository for the microservice."
  value       = module.ecs.ecr_repository_url
}

output "cicd_iam_role_arn" {
  description = "The ARN of the IAM role for CI/CD."
  value       = module.security.cicd_iam_role_arn
}