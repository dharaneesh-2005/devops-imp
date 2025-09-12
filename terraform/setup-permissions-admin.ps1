# Admin Script to Set Up AWS Permissions
# This script should be run by an AWS administrator or root user

param(
    [string]$UserName = "Dharaneesh"
)

Write-Host "🔐 Setting up AWS permissions for user: $UserName" -ForegroundColor Green

# List of policies to attach
$policies = @(
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess", 
    "arn:aws:iam::aws:policy/AmazonECS_FullAccess",
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
    "arn:aws:iam::aws:policy/IAMFullAccess"
)

foreach ($policy in $policies) {
    Write-Host "📋 Attaching policy: $policy" -ForegroundColor Yellow
    
    try {
        aws iam attach-user-policy --user-name $UserName --policy-arn $policy
        Write-Host "✅ Successfully attached policy" -ForegroundColor Green
    } catch {
        Write-Host "❌ Failed to attach policy: $_" -ForegroundColor Red
    }
}

Write-Host "🎉 Permission setup complete!" -ForegroundColor Green
Write-Host ""
Write-Host "📋 Attached Policies:" -ForegroundColor Cyan
foreach ($policy in $policies) {
    Write-Host "  - $policy" -ForegroundColor White
}

Write-Host ""
Write-Host "🔧 Next Steps:" -ForegroundColor Cyan
Write-Host "  1. Run: aws s3 mb s3://devops-terraform-state-$(Get-Random -Minimum 1000 -Maximum 9999) --region ap-south-1" -ForegroundColor White
Write-Host "  2. Run: aws dynamodb create-table --table-name devops-project-terraform-state-lock --attribute-definitions AttributeName=LockID,AttributeType=S --key-schema AttributeName=LockID,KeyType=HASH --billing-mode PAY_PER_REQUEST --region ap-south-1" -ForegroundColor White
Write-Host "  3. Configure Terraform backend" -ForegroundColor White
