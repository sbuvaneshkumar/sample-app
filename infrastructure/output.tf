output "aws_lb" {
  description = "URL for ALB to access the app"
  value = module.vpc.aws_lb 
}
