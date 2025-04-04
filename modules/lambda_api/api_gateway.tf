# API Gateway resources

# HTTP API Gateway
resource "aws_apigatewayv2_api" "lambda_api" {
  name          = "${var.environment}-hello-world-api"
  protocol_type = "HTTP"
  description   = "HTTP API Gateway for Hello World Lambda function"

  cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["GET", "OPTIONS"]
    allow_headers = ["content-type"]
    max_age       = 300
  }

  tags = merge(
    {
      Environment = var.environment,
      Service     = "hello-world-api",
      ManagedBy   = "terraform"
    },
    var.tags
  )
}

# Default stage for the API Gateway
resource "aws_apigatewayv2_stage" "lambda_stage" {
  api_id      = aws_apigatewayv2_api.lambda_api.id
  name        = "$default"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gateway_logs.arn
    format = jsonencode({
      requestId      = "$context.requestId"
      ip             = "$context.identity.sourceIp"
      requestTime    = "$context.requestTime"
      httpMethod     = "$context.httpMethod"
      routeKey       = "$context.routeKey"
      status         = "$context.status"
      protocol       = "$context.protocol"
      responseLength = "$context.responseLength"
      path           = "$context.path"
    })
  }

  tags = merge(
    {
      Environment = var.environment,
      Service     = "hello-world-api",
      ManagedBy   = "terraform"
    },
    var.tags
  )
}

# CloudWatch Log Group for API Gateway
resource "aws_cloudwatch_log_group" "api_gateway_logs" {
  name              = "/aws/apigateway/${var.environment}-hello-world-api"
  retention_in_days = var.log_retention_days

  tags = merge(
    {
      Environment = var.environment,
      Service     = "hello-world-api",
      ManagedBy   = "terraform"
    },
    var.tags
  )
}

# Lambda integration with API Gateway
resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id                 = aws_apigatewayv2_api.lambda_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.hello_world.invoke_arn
  payload_format_version = "2.0"
  integration_method     = "POST"
}

# Route for the root path
resource "aws_apigatewayv2_route" "root_route" {
  api_id    = aws_apigatewayv2_api.lambda_api.id
  route_key = "GET /"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

# Route for the hello path
resource "aws_apigatewayv2_route" "hello_route" {
  api_id    = aws_apigatewayv2_api.lambda_api.id
  route_key = "GET /hello"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

# Permission for API Gateway to invoke Lambda
resource "aws_lambda_permission" "api_gateway_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.hello_world.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.lambda_api.execution_arn}/*/*"
}