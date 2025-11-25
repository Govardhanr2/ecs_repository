output "alb_sg_id" {
  description = "The ID of the ALB security group."
  value       = aws_security_group.alb.id
}

output "ecs_service_sg_id" {
  description = "The ID of the ECS service security group."
  value       = aws_security_group.ecs_service.id
}

output "rds_sg_id" {
  description = "The ID of the RDS security group."
  value       = aws_security_group.rds.id
}

output "cicd_iam_role_arn" {
  description = "The ARN of the IAM role for CI/CD."
  value       = aws_iam_role.github_actions.arn
}