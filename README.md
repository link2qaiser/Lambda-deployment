# AWS Lambda "Hello World" API

A serverless "Hello World" API built on AWS Lambda with API Gateway integration. This project uses FastAPI for the API implementation with a split workflow for infrastructure and code management.

## Project Overview

This repository contains:

- A FastAPI application deployed as an AWS Lambda function
- Terraform configurations for infrastructure management
- Serverless Framework for code deployments
- GitHub Actions workflow for CI/CD of code changes

## Deployment Strategy

This project uses a hybrid approach:

1. **Infrastructure**: Managed manually using Terraform from local development machine
2. **Code**: Deployed automatically via GitHub Actions using Serverless Framework

This separation allows for:
- Controlled infrastructure changes
- Fast and frequent code deployments
- Clear separation of concerns

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
- **Infrastructure as Code**: AWS resources defined and managed with Terraform
- **CI/CD for Code**: Automated testing and deployment of code changes
- **Lambda Layers**: Dependencies managed through Lambda layers

## Key Components

### Application Code (app/)
- FastAPI application code
- Automatically deployed by GitHub Actions

### Infrastructure (environments/ and modules/)
- Terraform configurations
- Managed manually from local machine

### Deployment (serverless.yml)
- Serverless Framework configuration
- Deploys code to existing infrastructure

## Getting Started

### Prerequisites

- AWS Account
- AWS CLI configured locally
- Terraform CLI (for infrastructure management)
- Node.js and npm (for Serverless Framework)
- Python 3.9+ (for local API development)

### Infrastructure Deployment

See [TERRAFORM_INFRASTRUCTURE.md](TERRAFORM_INFRASTRUCTURE.md) for detailed instructions.

```bash
# Initial setup
cd environments/dev
terraform init
terraform apply
```

### Code Deployment

See [SERVERLESS_DEPLOYMENT.md](SERVERLESS_DEPLOYMENT.md) for detailed instructions.

Code deployment happens automatically when you push to GitHub, or you can deploy manually:

```bash
npm install
npm run deploy:dev
```

### Local API Development

You can develop and test the FastAPI application locally:

```bash
cd app
pip install -r requirements.txt
python main.py
```

The API will be available at http://localhost:8000 with documentation at http://localhost:8000/docs

## Documentation

- [TERRAFORM_INFRASTRUCTURE.md](TERRAFORM_INFRASTRUCTURE.md) - Infrastructure management
- [SERVERLESS_DEPLOYMENT.md](SERVERLESS_DEPLOYMENT.md) - Code deployment details

## License

[MIT](LICENSE)