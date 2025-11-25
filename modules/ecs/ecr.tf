resource "aws_ecr_repository" "microservice" {
  name = "microservice"
  
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "microservice-ecr-repo"
  }
}