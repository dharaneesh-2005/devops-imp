@echo off
REM Terraform Backend Setup Script for Windows
REM This script helps set up the S3 backend for Terraform state management

echo 🚀 Setting up Terraform Backend Infrastructure...

REM Check if AWS CLI is configured
aws sts get-caller-identity >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ AWS CLI is not configured. Please run 'aws configure' first.
    pause
    exit /b 1
)

echo ✅ AWS CLI is configured

REM Get AWS account ID and region
for /f "tokens=*" %%i in ('aws sts get-caller-identity --query Account --output text') do set AWS_ACCOUNT_ID=%%i
for /f "tokens=*" %%i in ('aws configure get region') do set AWS_REGION=%%i

if "%AWS_REGION%"=="" (
    set AWS_REGION=us-west-2
    echo ⚠️  No region configured, using default: %AWS_REGION%
)

echo 📊 AWS Account ID: %AWS_ACCOUNT_ID%
echo 🌍 AWS Region: %AWS_REGION%

REM Create backend infrastructure
echo 🏗️  Creating S3 bucket and DynamoDB table for Terraform state...

terraform init
terraform apply -auto-approve -var="aws_region=%AWS_REGION%"

REM Get the created resources
for /f "tokens=*" %%i in ('terraform output -raw s3_bucket_name') do set S3_BUCKET=%%i
for /f "tokens=*" %%i in ('terraform output -raw dynamodb_table_name') do set DYNAMODB_TABLE=%%i

echo ✅ Backend infrastructure created:
echo    S3 Bucket: %S3_BUCKET%
echo    DynamoDB Table: %DYNAMODB_TABLE%

REM Create backend configuration file
echo bucket = "%S3_BUCKET%" > backend-config.hcl
echo key    = "devops-project/terraform.tfstate" >> backend-config.hcl
echo region = "%AWS_REGION%" >> backend-config.hcl
echo dynamodb_table = "%DYNAMODB_TABLE%" >> backend-config.hcl
echo encrypt = true >> backend-config.hcl

echo 📝 Backend configuration saved to backend-config.hcl

REM Initialize main Terraform with backend
echo 🔄 Initializing main Terraform configuration with S3 backend...
cd ..
terraform init -backend-config=terraform/backend-config.hcl

echo 🎉 Setup complete! You can now run:
echo    terraform plan
echo    terraform apply

pause

