# modules/lambda_api/variables.tf
variable "environment" {
  description = "Deployment environment (dev/staging/prod)"
  type        = string
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
}

variable "log_retention_days" {
  description = "Number of days to retain CloudWatch logs"
  type        = number
  default     = 7
}

variable "lambda_timeout" {
  description = "Lambda function timeout in seconds"
  type        = number
  default     = 30
}

variable "lambda_memory_size" {
  description = "Amount of memory available to the Lambda function"
  type        = number
  default     = 256
}

variable "enable_detailed_monitoring" {
  description = "Enable detailed CloudWatch monitoring"
  type        = bool
  default     = true
}

variable "api_error_threshold" {
  description = "Threshold for API error alarms"
  type        = number
  default     = 5
}

variable "alarm_actions" {
  description = "List of alarm action ARNs"
  type        = list(string)
  default     = []
}

variable "ok_actions" {
  description = "List of OK action ARNs"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}