# Getting Started Guide

## Prerequisites

Before you begin, ensure you have the following installed:

### Required Software
1. **Docker Desktop** - [Download here](https://www.docker.com/products/docker-desktop/)
2. **Node.js** (v18 or later) - [Download here](https://nodejs.org/)
3. **Git** - [Download here](https://git-scm.com/)
4. **AWS CLI** - [Installation guide](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
5. **Terraform** - [Download here](https://www.terraform.io/downloads)

### Required Accounts
1. **AWS Account** - [Sign up here](https://aws.amazon.com/)
2. **GitHub Account** - [Sign up here](https://github.com/)

## Quick Start

### Step 1: Clone and Setup
```bash
# Clone the repository
git clone <your-repo-url>
cd "devops imp"

# Install Node.js dependencies
cd src/app
npm install
```

### Step 2: Test Locally with Docker
```bash
# Build the Docker image
docker build -f ../../docker/Dockerfile -t devops-app .

# Run the container
docker run -p 3000:3000 devops-app

# Test the application
curl http://localhost:3000/health
```

### Step 3: AWS Setup
```bash
# Configure AWS CLI
aws configure

# Create AWS credentials
# Access Key ID: [Your Access Key]
# Secret Access Key: [Your Secret Key]
# Default region: us-west-2
# Default output format: json
```

### Step 4: Terraform Infrastructure
```bash
# Navigate to terraform directory
cd terraform

# Initialize Terraform
terraform init

# Plan the infrastructure
terraform plan

# Apply the infrastructure (when ready)
terraform apply
```

### Step 5: GitHub Actions Setup
1. Push your code to GitHub
2. Go to your repository settings
3. Add the following secrets:
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`
4. The CI/CD pipeline will automatically run

## Learning Path

### Phase 1: Docker (Week 1-2)
- [ ] Read the [Docker Guide](docker-guide.md)
- [ ] Complete Docker exercises
- [ ] Build and test your first container
- [ ] Understand multi-stage builds

**Goals:**
- Understand containerization concepts
- Build optimized Docker images
- Use Docker Compose for local development

### Phase 2: Terraform & AWS (Week 3-4)
- [ ] Set up AWS account and credentials
- [ ] Learn Terraform basics
- [ ] Provision VPC and networking
- [ ] Create ECS cluster and ECR repository

**Goals:**
- Understand Infrastructure as Code
- Provision AWS resources with Terraform
- Implement best practices for IaC

### Phase 3: GitHub Actions (Week 5-6)
- [ ] Learn GitHub Actions workflow syntax
- [ ] Create build and test pipelines
- [ ] Implement automated deployments
- [ ] Set up environment-specific workflows

**Goals:**
- Build complete CI/CD pipelines
- Automate build, test, and deployment
- Implement security scanning

### Phase 4: Integration (Week 7-8)
- [ ] Deploy complete application
- [ ] Test all pipeline stages
- [ ] Implement monitoring
- [ ] Document the setup

**Goals:**
- Integrate all components
- Test complete pipeline
- Implement monitoring and logging

## Project Structure

```
devops imp/
├── src/app/                 # Sample Node.js application
│   ├── package.json        # Dependencies and scripts
│   ├── server.js           # Main application file
│   └── test/               # Unit tests
├── docker/                 # Docker configurations
│   ├── Dockerfile          # Multi-stage Docker build
│   ├── docker-compose.yml  # Local development setup
│   └── .dockerignore       # Docker ignore file
├── terraform/              # Infrastructure as Code
│   ├── main.tf            # Main Terraform configuration
│   ├── variables.tf       # Variable definitions
│   ├── iam.tf             # IAM roles and policies
│   └── outputs.tf         # Output values
├── github-actions/         # CI/CD pipelines
│   └── ci-cd.yml          # GitHub Actions workflow
└── docs/                  # Documentation
    ├── learning-path.md   # Detailed learning guide
    ├── docker-guide.md    # Docker learning guide
    └── getting-started.md # This file
```

## Common Commands

### Docker Commands
```bash
# Build image
docker build -t my-app .

# Run container
docker run -p 3000:3000 my-app

# View logs
docker logs <container-id>

# Stop container
docker stop <container-id>

# Remove container
docker rm <container-id>

# Clean up
docker system prune
```

### Terraform Commands
```bash
# Initialize
terraform init

# Plan changes
terraform plan

# Apply changes
terraform apply

# Destroy infrastructure
terraform destroy

# Format code
terraform fmt

# Validate configuration
terraform validate
```

### AWS CLI Commands
```bash
# List ECR repositories
aws ecr describe-repositories

# List ECS clusters
aws ecs list-clusters

# View ECS services
aws ecs list-services --cluster <cluster-name>

# View logs
aws logs describe-log-groups
```

## Troubleshooting

### Common Issues

**Docker Issues:**
- Port conflicts: Use different ports or stop conflicting services
- Permission issues: Check Docker daemon permissions
- Build failures: Check Dockerfile syntax and dependencies

**Terraform Issues:**
- State lock: Run `terraform force-unlock <lock-id>`
- Provider issues: Run `terraform init -upgrade`
- Permission issues: Check AWS credentials and IAM permissions

**GitHub Actions Issues:**
- Secret not found: Check repository settings
- AWS authentication: Verify OIDC configuration
- Build failures: Check workflow syntax and dependencies

### Getting Help

1. Check the documentation in the `docs/` directory
2. Review error logs in GitHub Actions
3. Check AWS CloudWatch logs
4. Use `terraform plan` to preview changes
5. Test locally with Docker before deploying

## Next Steps

Once you've completed the basic setup:

1. **Customize the application** - Modify the Node.js app to your needs
2. **Add more services** - Create additional microservices
3. **Implement monitoring** - Add CloudWatch dashboards and alarms
4. **Security hardening** - Implement security best practices
5. **Cost optimization** - Optimize AWS resources for cost
6. **Disaster recovery** - Implement backup and recovery procedures

## Resources

- [Docker Documentation](https://docs.docker.com/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [AWS ECS Documentation](https://docs.aws.amazon.com/ecs/)
- [AWS ECR Documentation](https://docs.aws.amazon.com/ecr/)

Happy learning! 🚀
