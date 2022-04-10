module "vpc" {
  source = "./modules/network"
  environment = var.environment
  app_name = var.app_name
}

module "ecr" {
  source = "./modules/ecr"
  ecr_repo_name = var.app_name
}
