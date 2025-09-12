# PowerShell script to create AWS resources for Terraform backend
# Run this after adding the necessary IAM permissions

Write-Host "🚀 Setting up AWS resources for Terraform backend..." -ForegroundColor Green

# Generate unique suffix for bucket name
$bucketSuffix = Get-Random -Minimum 1000 -Maximum 9999
$bucketName = "devops-project-terraform-state-$bucketSuffix"
$tableName = "devops-project-terraform-state-lock"
$region = "ap-south-1"

Write-Host "📦 Creating S3 bucket: $bucketName" -ForegroundColor Yellow

# Create S3 bucket
try {
    aws s3 mb "s3://$bucketName" --region $region
    Write-Host "✅ S3 bucket created successfully" -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to create S3 bucket: $_" -ForegroundColor Red
    exit 1
}

# Enable versioning
Write-Host "🔄 Enabling S3 bucket versioning..." -ForegroundColor Yellow
aws s3api put-bucket-versioning --bucket $bucketName --versioning-configuration Status=Enabled

# Enable encryption
Write-Host "🔐 Enabling S3 bucket encryption..." -ForegroundColor Yellow
aws s3api put-bucket-encryption --bucket $bucketName --server-side-encryption-configuration '{
    "Rules": [
        {
            "ApplyServerSideEncryptionByDefault": {
                "SSEAlgorithm": "AES256"
            }
        }
    ]
}'

# Block public access
Write-Host "🛡️ Blocking public access..." -ForegroundColor Yellow
aws s3api put-public-access-block --bucket $bucketName --public-access-block-configuration '{
    "BlockPublicAcls": true,
    "IgnorePublicAcls": true,
    "BlockPublicPolicy": true,
    "RestrictPublicBuckets": true
}'

Write-Host "📊 Creating DynamoDB table: $tableName" -ForegroundColor Yellow

# Create DynamoDB table
try {
    aws dynamodb create-table `
        --table-name $tableName `
        --attribute-definitions AttributeName=LockID,AttributeType=S `
        --key-schema AttributeName=LockID,KeyType=HASH `
        --billing-mode PAY_PER_REQUEST `
        --region $region
    
    Write-Host "✅ DynamoDB table created successfully" -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to create DynamoDB table: $_" -ForegroundColor Red
    exit 1
}

# Wait for table to be active
Write-Host "⏳ Waiting for DynamoDB table to be active..." -ForegroundColor Yellow
aws dynamodb wait table-exists --table-name $tableName --region $region

Write-Host "🎉 AWS resources created successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "📋 Resource Details:" -ForegroundColor Cyan
Write-Host "  S3 Bucket: $bucketName" -ForegroundColor White
Write-Host "  DynamoDB Table: $tableName" -ForegroundColor White
Write-Host "  Region: $region" -ForegroundColor White
Write-Host ""
Write-Host "🔧 Next steps:" -ForegroundColor Cyan
Write-Host "  1. Update terraform/backend.tf with these values" -ForegroundColor White
Write-Host "  2. Run: terraform init -backend-config=backend-config.hcl" -ForegroundColor White
Write-Host "  3. Run: terraform plan" -ForegroundColor White

# Create backend config file
$backendConfig = @"
bucket = "$bucketName"
key    = "devops-project/terraform.tfstate"
region = "$region"
dynamodb_table = "$tableName"
encrypt = true
"@

$backendConfig | Out-File -FilePath "terraform/backend-config.hcl" -Encoding UTF8
Write-Host "📝 Backend configuration saved to terraform/backend-config.hcl" -ForegroundColor Green
