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