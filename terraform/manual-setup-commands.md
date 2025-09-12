# Manual AWS Resource Setup Commands

## Prerequisites
Make sure you have added these IAM policies to your AWS user via AWS Console:
- AmazonS3FullAccess
- AmazonDynamoDBFullAccess
- AmazonECS_FullAccess
- AmazonEC2FullAccess
- IAMFullAccess

## Step 1: Create S3 Bucket
```bash
# Generate unique bucket name
aws s3 mb s3://devops-project-terraform-state-$(Get-Random -Minimum 1000 -Maximum 9999) --region ap-south-1

# Enable versioning
aws s3api put-bucket-versioning --bucket YOUR_BUCKET_NAME --versioning-configuration Status=Enabled

# Enable encryption
aws s3api put-bucket-encryption --bucket YOUR_BUCKET_NAME --server-side-encryption-configuration '{
    "Rules": [
        {
            "ApplyServerSideEncryptionByDefault": {
                "SSEAlgorithm": "AES256"
            }
        }
    ]
}'

# Block public access
aws s3api put-public-access-block --bucket YOUR_BUCKET_NAME --public-access-block-configuration '{
    "BlockPublicAcls": true,
    "IgnorePublicAcls": true,
    "BlockPublicPolicy": true,
    "RestrictPublicBuckets": true
}'
```

## Step 2: Create DynamoDB Table
```bash
aws dynamodb create-table \
    --table-name devops-project-terraform-state-lock \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST \
    --region ap-south-1

# Wait for table to be active
aws dynamodb wait table-exists --table-name devops-project-terraform-state-lock --region ap-south-1
```

## Step 3: Create Backend Config File
Create `terraform/backend-config.hcl` with:
```
bucket = "YOUR_BUCKET_NAME"
key    = "devops-project/terraform.tfstate"
region = "ap-south-1"
dynamodb_table = "devops-project-terraform-state-lock"
encrypt = true
```

## Step 4: Initialize Terraform
```bash
cd terraform
terraform init -backend-config=backend-config.hcl
terraform plan
terraform apply
```
