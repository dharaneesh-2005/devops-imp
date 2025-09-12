# Terraform Infrastructure Setup

This directory contains the Terraform configuration for the DevOps automation project, including VPC, ECS, ALB, and S3 backend for state management.

## 🏗️ Architecture

### Modules
- **VPC Module** (`modules/vpc/`): VPC, subnets, NAT gateways, route tables
- **ECS Module** (`modules/ecs/`): ECS cluster, ECR repository, task definitions, services
- **ALB Module** (`modules/alb/`): Application Load Balancer, target groups, listeners

### Backend
- **S3 Bucket**: For Terraform state storage
- **DynamoDB Table**: For state locking
- **Encryption**: State files are encrypted

## 🚀 Quick Start

### Prerequisites
1. **AWS CLI** configured with credentials
2. **Terraform** installed locally
3. **AWS Account** with appropriate permissions

### Step 1: Set Up Backend Infrastructure

#### Windows:
```bash
cd terraform
setup-backend.bat
```

#### Linux/Mac:
```bash
cd terraform
chmod +x setup-backend.sh
./setup-backend.sh
```

### Step 2: Initialize and Plan

```bash
# Initialize Terraform
terraform init

# Validate configuration
terraform validate

# Plan infrastructure
terraform plan
```

### Step 3: Apply Infrastructure

```bash
# Apply infrastructure
terraform apply
```

## 📁 Directory Structure

```
terraform/
├── modules/
│   ├── vpc/           # VPC and networking
│   ├── ecs/           # ECS cluster and services
│   └── alb/           # Application Load Balancer
├── backend-setup.tf   # Backend infrastructure
├── backend.tf         # Backend configuration
├── main.tf            # Main configuration
├── variables.tf       # Input variables
├── outputs.tf         # Output values
├── iam.tf             # IAM roles and policies
└── setup-backend.*    # Setup scripts
```

## 🔧 Configuration

### Variables
- `project_name`: Name of the project
- `aws_region`: AWS region (default: us-west-2)
- `environment`: Environment name (dev/staging/prod)
- `vpc_cidr`: VPC CIDR block (default: 10.0.0.0/16)
- `task_cpu`: ECS task CPU (default: 256)
- `task_memory`: ECS task memory (default: 512)

### Outputs
- `alb_dns_name`: Load balancer DNS name
- `ecr_repository_url`: ECR repository URL
- `ecs_cluster_name`: ECS cluster name
- `vpc_id`: VPC ID

## 🎯 What Gets Created

### Networking
- VPC with public and private subnets
- Internet Gateway and NAT Gateways
- Route tables and associations
- Security groups

### Compute
- ECS Fargate cluster
- ECS service with task definition
- ECR repository for Docker images

### Load Balancing
- Application Load Balancer
- Target groups and health checks
- HTTP listener on port 80

### Storage & State
- S3 bucket for Terraform state
- DynamoDB table for state locking
- CloudWatch log groups

## 🔒 Security

- Private subnets for ECS tasks
- Security groups with minimal access
- Encrypted state storage
- IAM roles with least privilege

## 🧹 Cleanup

```bash
# Destroy infrastructure
terraform destroy
```

## 📊 Monitoring

- CloudWatch logs for ECS tasks
- ALB access logs
- Container insights enabled

## 🚨 Troubleshooting

### Common Issues

1. **Backend initialization fails**
   - Check AWS credentials
   - Verify S3 bucket exists
   - Check DynamoDB table permissions

2. **ECS service fails to start**
   - Check task definition
   - Verify ECR repository access
   - Check security group rules

3. **ALB health checks fail**
   - Verify application is running
   - Check health check path
   - Verify security group rules

### Useful Commands

```bash
# Check AWS credentials
aws sts get-caller-identity

# List ECS services
aws ecs list-services --cluster <cluster-name>

# Check ALB health
aws elbv2 describe-target-health --target-group-arn <target-group-arn>

# View ECS logs
aws logs describe-log-groups --log-group-name-prefix "/ecs/"
```
