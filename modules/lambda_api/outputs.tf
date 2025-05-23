# Lambda API Module - outputs.tf

output "function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.hello_world.function_name
}

output "function_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.hello_world.arn
}

output "invoke_arn" {
  description = "Invocation ARN of the Lambda function, used for API Gateway integration"
  value       = aws_lambda_function.hello_world.invoke_arn
}

output "lambda_role_arn" {
  description = "ARN of the IAM role used by Lambda"
  value       = aws_iam_role.lambda_role.arn
}

output "lambda_role_name" {
  description = "Name of the IAM role used by Lambda"
  value       = aws_iam_role.lambda_role.name
}

output "cloudwatch_log_group" {
  description = "Name of the CloudWatch log group for Lambda"
  value       = aws_cloudwatch_log_group.hello_world_logs.name
}

# API Gateway outputs
output "api_gateway_id" {
  description = "ID of the API Gateway"
  value       = aws_apigatewayv2_api.lambda_api.id
}

output "api_gateway_arn" {
  description = "ARN of the API Gateway"
  value       = aws_apigatewayv2_api.lambda_api.arn
}

output "api_gateway_endpoint" {
  description = "Base URL for API Gateway stage"
  value       = aws_apigatewayv2_stage.lambda_stage.invoke_url
}

output "api_hello_endpoint" {
  description = "URL for the /hello endpoint"
  value       = "${aws_apigatewayv2_stage.lambda_stage.invoke_url}/hello"
}

# Secrets Manager outputs
output "secrets_manager_arn" {
  description = "ARN of the Secrets Manager secret"
  value       = aws_secretsmanager_secret.api_config.arn
}

output "secrets_manager_name" {
  description = "Name of the Secrets Manager secret"
  value       = aws_secretsmanager_secret.api_config.name
}
