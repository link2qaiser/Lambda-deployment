# AWS Lambda "Hello World" API

A serverless "Hello World" API built on AWS Lambda with API Gateway integration. This project uses FastAPI for the API implementation and demonstrates infrastructure as code using Terraform with a complete CI/CD pipeline for multiple environments.

## Project Overview

This repository contains a fully automated deployment pipeline for a simple serverless API that:

- Runs on AWS Lambda using Python and FastAPI
- Exposes a public endpoint via Amazon API Gateway
- Includes monitoring via CloudWatch
- Follows infrastructure-as-code best practices using Terraform
- Implements a complete GitHub Actions workflow for CI/CD

## Architecture

```
┌─────────────┐      ┌─────────────┐      ┌─────────────┐
│             │      │             │      │             │
│  API        │──────▶  Lambda     │      │ CloudWatch  │
│  Gateway    │      │  Function   │──────▶ Logs        │
│             │      │  (FastAPI)  │      │             │
└─────────────┘      └─────────────┘      └─────────────┘
```

## Features

- **FastAPI Implementation**: Modern, fast API framework with automatic OpenAPI documentation
- **Multi-environment Support**: Separate configurations for dev, stage, and production
- **Infrastructure as Code**: All AWS resources defined and managed with Terraform
- **CI/CD Pipeline**: Automated deployments via GitHub Actions
- **Public API Endpoint**: Accessible via HTTPS
- **Monitoring & Logging**: Comprehensive logging via CloudWatch
- **Modular Design**: Reusable Terraform modules
- **Local Development Support**: Test API locally before deploying to AWS

## Deployment Flow

1. Developer pushes code to appropriate branch (dev/stage/main)
2. GitHub Actions workflow automatically triggers
3. Terraform provisions or updates infrastructure in the appropriate AWS environment
4. API endpoint becomes available for testing/use

## Getting Started

### Prerequisites

- AWS Account
- GitHub repository
- AWS CLI configured locally (for manual deployment)
- Terraform CLI (for local development)
- Python 3.9+ (for local API development)

### Setting Up

1. Fork/clone this repository
2. Add the following secrets to your GitHub repository:
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`
3. Create branches:
   - `dev` - Development environment
   - `stage` - Staging environment
   - `main` - Production environment

### Local API Development

You can develop and test the FastAPI application locally:

```bash
# Navigate to the app directory
cd app

# Create a local environment file
cp .env.example .env

# Install dependencies
pip install -r requirements.txt

# Run the FastAPI application locally
python main.py
```

The API will be available at http://localhost:8000 with documentation at http://localhost:8000/docs

### Terraform Deployment

```bash
# Navigate to desired environment
cd environments/dev

# Initialize Terraform
terraform init

# Plan changes
terraform plan

# Apply changes
terraform apply
```

After deployment, the API endpoint URLs will be displayed in the Terraform output.

## Project Structure

```
.
├── README.md
├── app/                # FastAPI application code
│   ├── main.py         # Main API implementation
│   ├── requirements.txt # Python dependencies
│   └── .env.example    # Environment variables template
├── environments/
│   ├── dev/            # Development environment configuration
│   ├── stage/          # Staging environment configuration
│   └── prod/           # Production environment configuration
├── modules/
│   └── lambda_api/     # Reusable Terraform module
│       ├── main.tf     # Lambda function definition
│       ├── api_gateway.tf # API Gateway resources
│       ├── variables.tf # Input variables
│       └── outputs.tf  # Output values
└── .github/
    └── workflows/      # GitHub Actions workflows
```

## Endpoints

- **GET /** - Root endpoint with API information
- **GET /hello** - Hello world endpoint that returns a greeting message with environment information
- **GET /docs** - OpenAPI documentation (available only when running locally)

## Environment Variables

### Local Development

Environment variables for local development can be set in the `.env` file. See `.env.example` for available options.

### AWS Deployment

Environment variables for AWS Lambda are defined in the Terraform configuration and can be customized per environment.

## Technologies Used

- **AWS Lambda**: For serverless function execution
- **Amazon API Gateway**: For creating RESTful APIs
- **AWS CloudWatch**: For monitoring and logging
- **Terraform**: For infrastructure as code
- **GitHub Actions**: For CI/CD pipeline
- **FastAPI**: Modern, fast Python web framework
- **Mangum**: AWS Lambda adapter for ASGI applications

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

[MIT](LICENSE)
