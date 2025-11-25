# ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = "main-cluster"

  tags = {
    Name = "main-cluster"
  }
}

# WordPress Task Definition
resource "aws_ecs_task_definition" "wordpress" {
  family                   = "wordpress"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "1024"
  memory                   = "2048"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "wordpress"
      image     = "wordpress:latest"
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
      environment = [
        {
          name  = "WORDPRESS_DB_HOST"
          value = var.db_address
        },
        {
          name  = "WORDPRESS_DB_NAME"
          value = var.db_name
        }
      ]
      secrets = [
        {
          name      = "WORDPRESS_DB_USER"
          valueFrom = "${var.db_credentials_secret_arn}:username::"
        },
        {
          name      = "WORDPRESS_DB_PASSWORD"
          valueFrom = "${var.db_credentials_secret_arn}:password::"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/wordpress"
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  tags = {
    Name = "wordpress-task"
  }
}

# Microservice Task Definition
resource "aws_ecs_task_definition" "microservice" {
  family                   = "microservice"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "microservice"
      image     = aws_ecr_repository.microservice.repository_url
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/microservice"
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  tags = {
    Name = "microservice-task"
  }
}

# WordPress Service
resource "aws_ecs_service" "wordpress" {
  name            = "wordpress-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.wordpress.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.private_subnet_ids
    security_groups = [var.ecs_service_sg_id]
  }

  load_balancer {
    target_group_arn = var.wordpress_tg_arn
    container_name   = "wordpress"
    container_port   = 80
  }

  

  tags = {
    Name = "wordpress-service"
  }
}

# Microservice Service
resource "aws_ecs_service" "microservice" {
  name            = "microservice-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.microservice.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.private_subnet_ids
    security_groups = [var.ecs_service_sg_id]
  }

  load_balancer {
    target_group_arn = var.microservice_tg_arn
    container_name   = "microservice"
    container_port   = 3000
  }

  

  tags = {
    Name = "microservice-service"
  }
}

# Auto Scaling for WordPress Service
resource "aws_appautoscaling_target" "wordpress" {
  max_capacity       = 4
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.wordpress.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "wordpress_cpu" {
  name               = "wordpress-cpu-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.wordpress.resource_id
  scalable_dimension = aws_appautoscaling_target.wordpress.scalable_dimension
  service_namespace  = aws_appautoscaling_target.wordpress.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value       = 75
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }
}

resource "aws_appautoscaling_policy" "wordpress_memory" {
  name               = "wordpress-memory-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.wordpress.resource_id
  scalable_dimension = aws_appautoscaling_target.wordpress.scalable_dimension
  service_namespace  = aws_appautoscaling_target.wordpress.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value       = 75
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
  }
}

# Auto Scaling for Microservice Service
resource "aws_appautoscaling_target" "microservice" {
  max_capacity       = 4
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.microservice.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "microservice_cpu" {
  name               = "microservice-cpu-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.microservice.resource_id
  scalable_dimension = aws_appautoscaling_target.microservice.scalable_dimension
  service_namespace  = aws_appautoscaling_target.microservice.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value       = 75
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }
}

resource "aws_appautoscaling_policy" "microservice_memory" {
  name               = "microservice-memory-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.microservice.resource_id
  scalable_dimension = aws_appautoscaling_target.microservice.scalable_dimension
  service_namespace  = aws_appautoscaling_target.microservice.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value       = 75
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
  }
}

# CloudWatch Log Group for WordPress
resource "aws_cloudwatch_log_group" "wordpress" {
  name = "/ecs/wordpress"

  tags = {
    Name = "wordpress-log-group"
  }
}

# CloudWatch Log Group for Microservice
resource "aws_cloudwatch_log_group" "microservice" {
  name = "/ecs/microservice"

  tags = {
    Name = "microservice-log-group"
  }
}