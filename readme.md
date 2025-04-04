# AWS Lambda "Hello World" API

A serverless "Hello World" API built on AWS Lambda with API Gateway integration. This project demonstrates infrastructure as code using Terraform with a complete CI/CD pipeline for multiple environments.

## Project Overview

This repository contains a fully automated deployment pipeline for a simple serverless API that:

- Runs on AWS Lambda (Node.js runtime)
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
│             │      │             │      │             │
└─────────────┘      └─────────────┘      └─────────────┘
```

## Features

- **Multi-environment Support**: Separate configurations for dev, stage, and production
- **Infrastructure as Code**: All AWS resources defined and managed with Terraform
- **CI/CD Pipeline**: Automated deployments via GitHub Actions
- **Public API Endpoint**: Accessible via HTTPS
- **Monitoring & Logging**: Comprehensive logging via CloudWatch
- **Modular Design**: Reusable Terraform modules

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

### Setting Up

1. Fork/clone this repository
2. Add the following secrets to your GitHub repository:
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`
3. Create branches:
   - `dev` - Development environment
   - `stage` - Staging environment
   - `main` - Production environment

### Local Development

```bash
# Clone the repository
git clone <repository-url>
cd <repository-directory>

# Navigate to desired environment
cd environments/dev

# Initialize Terraform
terraform init

# Apply changes
terraform apply
```

## Project Structure

```
.
├── README.md
├── environments/
│   ├── dev/        # Development environment configuration
│   ├── stage/      # Staging environment configuration
│   └── prod/       # Production environment configuration
├── modules/
│   └── lambda_api/ # Reusable Terraform module
└── .github/
    └── workflows/  # GitHub Actions workflows
```

## Technologies Used

- **AWS Lambda**: For serverless function execution
- **Amazon API Gateway**: For creating RESTful APIs
- **AWS CloudWatch**: For monitoring and logging
- **Terraform**: For infrastructure as code
- **GitHub Actions**: For CI/CD pipeline

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

[MIT](LICENSE)
