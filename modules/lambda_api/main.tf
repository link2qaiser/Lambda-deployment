# Lambda API Module - main.tf

# Create zip file for Lambda function from the app directory
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.root}/../../app"
  output_path = "${path.module}/lambda_function.zip"
}

# Define the Lambda function
resource "aws_lambda_function" "hello_world" {
  function_name = "${var.environment}-hello-world"
  filename      = data.archive_file.lambda_zip.output_path
  handler       = "main.handler"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_role.arn
  
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  
  environment {
    variables = {
      ENVIRONMENT = var.environment
    }
  }

  timeout     = var.lambda_timeout
  memory_size = var.lambda_memory_size

  tags = {
    Environment = var.environment
    Service     = "hello-world-api"
  }
}

# IAM role for Lambda function
resource "aws_iam_role" "lambda_role" {
  name = "${var.environment}-hello-world-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Environment = var.environment
  }
}

# CloudWatch logging permissions
resource "aws_iam_policy" "lambda_logging" {
  name        = "${var.environment}-hello-world-logging"
  description = "IAM policy for logging from the hello-world lambda"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

# Attach the logging policy to the Lambda role
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}