# S3 Backend Configuration for Terraform State Management
terraform {
  backend "s3" {
    # These will be provided via terraform init -backend-config
    # bucket = "your-terraform-state-bucket"
    # key    = "devops-project/terraform.tfstate"
    # region = "us-west-2"
    # dynamodb_table = "terraform-state-lock"
    # encrypt = true
  }
}

