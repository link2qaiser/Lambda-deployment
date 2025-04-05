# environments/dev/main.tf
module "lambda_api" {
  source = "../../modules/lambda_api"

  environment               = "dev"
  aws_region                = "us-east-1"
  log_retention_days        = 7
  lambda_timeout            = 30
  lambda_memory_size        = 256
  enable_detailed_monitoring = true
  api_error_threshold       = 5
  alarm_actions             = []
  ok_actions                = []
  tags = {
    Environment = "dev"
    Project     = "MyProject"
  }
}