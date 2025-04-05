# Development environment variables

environment       = "dev"
aws_region        = "us-east-1"
log_retention_days = 7

# Lambda configuration
lambda_timeout    = 30
lambda_memory_size = 256

# CloudWatch configuration
enable_detailed_monitoring = true
api_error_threshold = 5

# Additional tags
tags = {
  Owner       = "DevTeam"
  Project     = "HelloWorldAPI"
  CostCenter  = "Development"
}