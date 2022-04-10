module "vpc" {
  source      = "./modules/network"
  environment = var.environment
  app_name    = var.app_name
}

module "ecr" {
  source        = "./modules/ecr"
  ecr_repo_name = var.app_name
}

module "ecs" {
  source                      = "./modules/ecs"
  app_name                    = var.app_name
  ecr_repo_url                = module.ecr.ecr_repo_url
  app_image_tag               = var.app_image_tag
  private_subnets             = module.vpc.subnets.private
  aws_alb_target_group_arn    = module.vpc.aws_alb_target_group_arn
  ecs_service_security_groups = [module.vpc.security_group_ecs_tasks_id]
}

