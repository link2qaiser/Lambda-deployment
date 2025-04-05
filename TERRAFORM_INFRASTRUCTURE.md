# Terraform Infrastructure Management

This document explains how to manage the AWS infrastructure for the Hello World API using Terraform.

## Infrastructure Deployment

Infrastructure is managed **manually** from your local machine using Terraform. The CI/CD pipeline only handles code updates.

### Initial Setup

1. Navigate to the environment directory you want to deploy:

```bash
cd environments/dev   # or stage, prod
```

2. Initialize Terraform:

```bash
terraform init
```

3. Apply the infrastructure:

```bash
terraform apply
```

4. After deployment, note the output values, especially:

   - Lambda function name
   - Lambda role ARN
   - API Gateway endpoint

5. Store the Lambda role ARN in SSM Parameter Store so the CI/CD pipeline can access it:

```bash
aws ssm put-parameter \
    --name "/lambda-hello-world/dev/role-arn" \
    --type "String" \
    --value "arn:aws:iam::123456789012:role/dev-hello-world-role" \
    --overwrite
```

### Updating Infrastructure

When you need to make changes to the infrastructure:

1. Update the relevant Terraform files
2. Navigate to the environment directory
3. Run:

```bash
terraform plan    # Review changes
terraform apply   # Apply changes
```

### Important Notes

- **Never** run `terraform destroy` in production without a backup plan
- Always use the same region (us-east-2) for all environments
- Remember to update all environments when making structural changes

## Resources Created

Terraform creates the following resources:

- Lambda function with basic code
- API Gateway HTTP API
- CloudWatch log groups
- IAM roles and policies
- CloudWatch alarms and dashboard
- Secrets Manager secret

## Folder Structure

```
├── environments/
│   ├── dev/        # Development environment
│   ├── stage/      # Staging environment
│   └── prod/       # Production environment
└── modules/
    └── lambda_api/ # Reusable module for Lambda API
```

## Manual Operations

Some operations that need to be done manually:

1. Initial infrastructure deployment for each environment
2. Infrastructure updates
3. Initial role ARN configuration in SSM Parameter Store
4. Creating and managing any additional resources not in Terraform

## Connecting to CI/CD

The GitHub Actions workflow will:

1. Only update Lambda code and dependencies, not infrastructure
2. Use the Serverless Framework to deploy to the Lambda functions created by Terraform
3. Rely on the IAM roles created by Terraform
