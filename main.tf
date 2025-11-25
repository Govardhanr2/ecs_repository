terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "networking" {
  source = "./modules/networking"

  aws_region            = var.aws_region
  vpc_cidr              = var.vpc_cidr
  public_subnets_cidr   = var.public_subnets_cidr
  private_subnets_cidr  = var.private_subnets_cidr
}

module "security" {
  source = "./modules/security"

  vpc_id          = module.networking.vpc_id
  github_org      = var.github_org
  github_repo     = var.github_repo
  aws_account_id  = var.aws_account_id
}

module "rds" {
  source = "./modules/rds"

  private_subnet_ids = module.networking.private_subnet_ids
  rds_sg_id          = module.security.rds_sg_id
  db_username        = var.db_username
  db_password        = var.db_password
}

module "alb" {
  source = "./modules/alb"

  vpc_id             = module.networking.vpc_id
  public_subnet_ids  = module.networking.public_subnet_ids
  alb_sg_id          = module.security.alb_sg_id
  domain_name        = var.domain_name
}

module "ecs" {
  source = "./modules/ecs"

  aws_region                = var.aws_region
  private_subnet_ids        = module.networking.private_subnet_ids
  ecs_service_sg_id         = module.security.ecs_service_sg_id
  wordpress_tg_arn          = module.alb.wordpress_tg_arn
  microservice_tg_arn       = module.alb.microservice_tg_arn
  httpss_listener_arn       = module.alb.httpss_listener_arn
  db_address                = module.rds.db_instance_address
  db_name                   = module.rds.db_instance_name
  db_credentials_secret_arn = module.rds.db_credentials_secret_arn
}