#!/bin/bash

# Terraform Backend Setup Script
# This script helps set up the S3 backend for Terraform state management

echo "🚀 Setting up Terraform Backend Infrastructure..."

# Check if AWS CLI is configured
if ! aws sts get-caller-identity > /dev/null 2>&1; then
    echo "❌ AWS CLI is not configured. Please run 'aws configure' first."
    exit 1
fi

echo "✅ AWS CLI is configured"

# Get AWS account ID and region
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
AWS_REGION=$(aws configure get region)

if [ -z "$AWS_REGION" ]; then
    AWS_REGION="us-west-2"
    echo "⚠️  No region configured, using default: $AWS_REGION"
fi

echo "📊 AWS Account ID: $AWS_ACCOUNT_ID"
echo "🌍 AWS Region: $AWS_REGION"

# Create backend infrastructure
echo "🏗️  Creating S3 bucket and DynamoDB table for Terraform state..."

terraform init
terraform apply -auto-approve -var="aws_region=$AWS_REGION"

# Get the created resources
S3_BUCKET=$(terraform output -raw s3_bucket_name)
DYNAMODB_TABLE=$(terraform output -raw dynamodb_table_name)

echo "✅ Backend infrastructure created:"
echo "   S3 Bucket: $S3_BUCKET"
echo "   DynamoDB Table: $DYNAMODB_TABLE"

# Create backend configuration file
cat > backend-config.hcl << EOF
bucket = "$S3_BUCKET"
key    = "devops-project/terraform.tfstate"
region = "$AWS_REGION"
dynamodb_table = "$DYNAMODB_TABLE"
encrypt = true
EOF

echo "📝 Backend configuration saved to backend-config.hcl"

# Initialize main Terraform with backend
echo "🔄 Initializing main Terraform configuration with S3 backend..."
cd ..
terraform init -backend-config=terraform/backend-config.hcl

echo "🎉 Setup complete! You can now run:"
echo "   terraform plan"
echo "   terraform apply"

