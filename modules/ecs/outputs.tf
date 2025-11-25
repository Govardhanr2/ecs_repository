output "ecr_repository_url" {
  description = "The URL of the ECR repository."
  value       = aws_ecr_repository.microservice.repository_url
}

output "ecs_task_execution_role_arn" {
  description = "The ARN of the ECS task execution role."
  value       = aws_iam_role.ecs_task_execution_role.arn
}