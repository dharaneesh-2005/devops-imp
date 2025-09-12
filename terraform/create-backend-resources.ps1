# Create AWS Backend Resources for Terraform
# This script creates S3 bucket and DynamoDB table for Terraform state management

param(
    [string]$Region = "ap-south-1",
    [string]$ProjectName = "devops-project"
)

Write-Host "🚀 Creating AWS Backend Resources for Terraform" -ForegroundColor Green
Write-Host "Region: $Region" -ForegroundColor Cyan
Write-Host "Project: $ProjectName" -ForegroundColor Cyan

# Generate unique suffix
$suffix = Get-Random -Minimum 1000 -Maximum 9999
$bucketName = "$ProjectName-terraform-state-$suffix"
$tableName = "$ProjectName-terraform-state-lock"

Write-Host "📦 Creating S3 bucket: $bucketName" -ForegroundColor Yellow

# Create S3 bucket
$createBucketResult = aws s3 mb "s3://$bucketName" --region $Region 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ S3 bucket created: $bucketName" -ForegroundColor Green
} else {
    Write-Host "❌ Failed to create S3 bucket: $createBucketResult" -ForegroundColor Red
    exit 1
}

# Configure S3 bucket
Write-Host "🔧 Configuring S3 bucket..." -ForegroundColor Yellow

# Enable versioning
aws s3api put-bucket-versioning --bucket $bucketName --versioning-configuration Status=Enabled --region $Region

# Enable encryption
$encryptionConfig = @{
    Rules = @(
        @{
            ApplyServerSideEncryptionByDefault = @{
                SSEAlgorithm = "AES256"
            }
        }
    )
} | ConvertTo-Json -Depth 3

aws s3api put-bucket-encryption --bucket $bucketName --server-side-encryption-configuration $encryptionConfig --region $Region

# Block public access
$publicAccessConfig = @{
    BlockPublicAcls = $true
    IgnorePublicAcls = $true
    BlockPublicPolicy = $true
    RestrictPublicBuckets = $true
} | ConvertTo-Json -Depth 2

aws s3api put-public-access-block --bucket $bucketName --public-access-block-configuration $publicAccessConfig --region $Region

Write-Host "📊 Creating DynamoDB table: $tableName" -ForegroundColor Yellow

# Create DynamoDB table
$createTableResult = aws dynamodb create-table `
    --table-name $tableName `
    --attribute-definitions AttributeName=LockID,AttributeType=S `
    --key-schema AttributeName=LockID,KeyType=HASH `
    --billing-mode PAY_PER_REQUEST `
    --region $Region 2>&1

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ DynamoDB table created: $tableName" -ForegroundColor Green
} else {
    Write-Host "❌ Failed to create DynamoDB table: $createTableResult" -ForegroundColor Red
    exit 1
}

# Wait for table to be active
Write-Host "⏳ Waiting for DynamoDB table to be active..." -ForegroundColor Yellow
aws dynamodb wait table-exists --table-name $tableName --region $Region

Write-Host "🎉 AWS Backend Resources Created Successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "📋 Resource Details:" -ForegroundColor Cyan
Write-Host "  S3 Bucket: $bucketName" -ForegroundColor White
Write-Host "  DynamoDB Table: $tableName" -ForegroundColor White
Write-Host "  Region: $Region" -ForegroundColor White

# Create backend configuration file
$backendConfig = @"
bucket = "$bucketName"
key    = "devops-project/terraform.tfstate"
region = "$Region"
dynamodb_table = "$tableName"
encrypt = true
"@

$backendConfig | Out-File -FilePath "backend-config.hcl" -Encoding UTF8
Write-Host "📝 Backend configuration saved to backend-config.hcl" -ForegroundColor Green

Write-Host ""
Write-Host "🔧 Next Steps:" -ForegroundColor Cyan
Write-Host "  1. cd terraform" -ForegroundColor White
Write-Host "  2. terraform init -backend-config=../backend-config.hcl" -ForegroundColor White
Write-Host "  3. terraform plan" -ForegroundColor White
Write-Host "  4. terraform apply" -ForegroundColor White
