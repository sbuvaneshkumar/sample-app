module "vpc" {
  source = "./modules/network"
  environment = var.environment
  app_name = var.app_name
}
