# CloudWatch logging setup for Lambda and API Gateway

# CloudWatch Log Group for Lambda
resource "aws_cloudwatch_log_group" "hello_world_logs" {
  name              = "/aws/lambda/${aws_lambda_function.hello_world.function_name}"
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

# CloudWatch Metric Alarm for Lambda errors
resource "aws_cloudwatch_metric_alarm" "lambda_error_alarm" {
  alarm_name          = "${var.environment}-hello-world-lambda-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = "60"
  statistic           = "Sum"
  threshold           = "0"
  alarm_description   = "This metric monitors lambda function errors"
  alarm_actions       = var.alarm_actions
  ok_actions          = var.ok_actions
  treat_missing_data  = "notBreaching"
  
  dimensions = {
    FunctionName = aws_lambda_function.hello_world.function_name
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

# CloudWatch Metric Alarm for API Gateway 4xx errors
resource "aws_cloudwatch_metric_alarm" "api_4xx_error_alarm" {
  alarm_name          = "${var.environment}-hello-world-api-4xx-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "4XXError"
  namespace           = "AWS/ApiGateway"
  period              = "300"
  statistic           = "Sum"
  threshold           = var.api_error_threshold
  alarm_description   = "This metric monitors API Gateway 4XX errors"
  alarm_actions       = var.alarm_actions
  ok_actions          = var.ok_actions
  treat_missing_data  = "notBreaching"
  
  dimensions = {
    ApiId = aws_apigatewayv2_api.lambda_api.id
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

# CloudWatch Dashboard for Hello World API
resource "aws_cloudwatch_dashboard" "hello_world_dashboard" {
  dashboard_name = "${var.environment}-hello-world-api-dashboard"
  
  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/Lambda", "Invocations", "FunctionName", aws_lambda_function.hello_world.function_name],
            ["AWS/Lambda", "Errors", "FunctionName", aws_lambda_function.hello_world.function_name],
            ["AWS/Lambda", "Duration", "FunctionName", aws_lambda_function.hello_world.function_name]
          ]
          period = 300
          stat   = "Sum"
          region = var.aws_region
          title  = "Lambda Metrics"
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/ApiGateway", "Count", "ApiId", aws_apigatewayv2_api.lambda_api.id],
            ["AWS/ApiGateway", "4XXError", "ApiId", aws_apigatewayv2_api.lambda_api.id],
            ["AWS/ApiGateway", "5XXError", "ApiId", aws_apigatewayv2_api.lambda_api.id]
          ]
          period = 300
          stat   = "Sum"
          region = var.aws_region
          title  = "API Gateway Metrics"
        }
      },
      {
        type   = "log"
        x      = 12
        y      = 0
        width  = 12
        height = 6
        properties = {
          query   = "SOURCE '${aws_cloudwatch_log_group.hello_world_logs.name}' | fields @timestamp, @message\n| sort @timestamp desc\n| limit 20"
          region  = var.aws_region
          title   = "Latest Lambda Logs"
          view    = "table"
        }
      },
      {
        type   = "log"
        x      = 12
        y      = 6
        width  = 12
        height = 6
        properties = {
          query   = "SOURCE '${aws_cloudwatch_log_group.api_gateway_logs.name}' | fields @timestamp, @message\n| sort @timestamp desc\n| limit 20"
          region  = var.aws_region
          title   = "Latest API Gateway Logs"
          view    = "table"
        }
      }
    ]
  })
}