# API Gateway resources with enhanced CloudWatch logging

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

# Default stage for the API Gateway with detailed logging
resource "aws_apigatewayv2_stage" "lambda_stage" {
  api_id      = aws_apigatewayv2_api.lambda_api.id
  name        = "$default"
  auto_deploy = true

  # Access logging configuration
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gateway_logs.arn
    format = jsonencode({
      requestId                = "$context.requestId"
      extendedRequestId        = "$context.extendedRequestId"
      ip                       = "$context.identity.sourceIp"
      caller                   = "$context.identity.caller"
      user                     = "$context.identity.user"
      requestTime              = "$context.requestTime"
      httpMethod               = "$context.httpMethod"
      resourcePath             = "$context.resourcePath"
      status                   = "$context.status"
      protocol                 = "$context.protocol"
      responseLength           = "$context.responseLength"
      integrationErrorMessage  = "$context.integrationErrorMessage"
      integrationLatency       = "$context.integration.latency"
      integrationStatus        = "$context.integration.status"
      latency                  = "$context.latency"
      path                     = "$context.path"
      routeKey                 = "$context.routeKey"
      stage                    = "$context.stage"
    })
  }

  # Set up detailed metrics if enabled
  default_route_settings {
    throttling_burst_limit = 100
    throttling_rate_limit  = 50
    detailed_metrics_enabled = var.enable_detailed_monitoring
  }

  tags = merge(
    {
      Environment = var.environment,
      Service     = "hello-world-api",
      ManagedBy   = "terraform"
    },
    var.tags
  )

  # Ensure log group exists before the stage
  depends_on = [aws_cloudwatch_log_group.api_gateway_logs]
}

# Lambda integration with API Gateway
resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id                 = aws_apigatewayv2_api.lambda_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.hello_world.invoke_arn
  payload_format_version = "2.0"
  integration_method     = "POST"
  
  # Enable logging to see request/response in CloudWatch
  integration_method     = "POST"
  timeout_milliseconds   = 30000  # 30 seconds
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