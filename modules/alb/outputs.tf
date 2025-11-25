output "lb_dns_name" {
  description = "The DNS name of the load balancer."
  value       = aws_lb.main.dns_name
}

output "lb_zone_id" {
  description = "The zone ID of the load balancer."
  value       = aws_lb.main.zone_id
}

output "httpss_listener_arn" {
  description = "The ARN of the HTTPS listener."
  value       = aws_lb_listener.https.arn
}

output "wordpress_tg_arn" {
  description = "The ARN of the WordPress target group."
  value       = aws_lb_target_group.wordpress.arn
}

output "microservice_tg_arn" {
  description = "The ARN of the microservice target group."
  value       = aws_lb_target_group.microservice.arn
}