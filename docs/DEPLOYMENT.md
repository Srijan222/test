# Deployment Guide

Comprehensive guide for deploying the Claude Cloud Environment to AWS.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Initial Setup](#initial-setup)
3. [Infrastructure Deployment](#infrastructure-deployment)
4. [Application Deployment](#application-deployment)
5. [Post-Deployment](#post-deployment)
6. [Rollback Procedures](#rollback-procedures)

## Prerequisites

### Required Tools

- AWS CLI (v2.x or higher)
- Terraform (v1.0 or higher)
- Docker (v20.x or higher)
- Node.js (v20.x or higher)

### AWS Account Setup

1. Create or use an existing AWS account
2. Configure AWS CLI with appropriate credentials:
   ```bash
   aws configure
   ```

3. Ensure you have the following IAM permissions:
   - EC2 (VPC, Security Groups, Subnets)
   - ECS (Clusters, Services, Tasks)
   - ECR (Repositories)
   - CloudWatch (Logs, Metrics)
   - Secrets Manager
   - IAM (Roles, Policies)

## Initial Setup

### 1. Create ECR Repository

```bash
aws ecr create-repository \
  --repository-name claude-cloud-environment \
  --region us-east-1 \
  --image-scanning-configuration scanOnPush=true
```

Save the repository URI for later use.

### 2. Create S3 Bucket for Terraform State

```bash
aws s3 mb s3://claude-terraform-state-$(aws sts get-caller-identity --query Account --output text) \
  --region us-east-1

# Enable versioning
aws s3api put-bucket-versioning \
  --bucket claude-terraform-state-$(aws sts get-caller-identity --query Account --output text) \
  --versioning-configuration Status=Enabled
```

### 3. Store API Key in Secrets Manager

```bash
aws secretsmanager create-secret \
  --name claude-anthropic-api-key-prod \
  --description "Anthropic API Key for Claude" \
  --secret-string "your-actual-api-key-here" \
  --region us-east-1
```

## Infrastructure Deployment

### 1. Configure Terraform Variables

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars`:
```hcl
aws_region = "us-east-1"
environment = "prod"
ecr_repository_url = "<account-id>.dkr.ecr.us-east-1.amazonaws.com/claude-cloud-environment"
anthropic_api_key = "your-api-key"  # Or use AWS Secrets Manager
```

### 2. Initialize Terraform

```bash
terraform init
```

### 3. Plan Infrastructure

```bash
terraform plan -out=tfplan
```

Review the plan carefully before applying.

### 4. Apply Infrastructure

```bash
terraform apply tfplan
```

This will create:
- VPC with public subnets
- ECS Cluster
- Security Groups
- IAM Roles
- CloudWatch Log Groups
- Secrets Manager entries

### 5. Save Outputs

```bash
terraform output > ../outputs.txt
```

## Application Deployment

### 1. Build Docker Image

```bash
cd ..
docker build -t claude-cloud-environment .
```

### 2. Tag for ECR

```bash
ECR_REPO=$(terraform -chdir=terraform output -raw ecr_repository_url 2>/dev/null || echo "<your-ecr-repo>")
docker tag claude-cloud-environment:latest $ECR_REPO:latest
docker tag claude-cloud-environment:latest $ECR_REPO:$(git rev-parse --short HEAD)
```

### 3. Login to ECR

```bash
aws ecr get-login-password --region us-east-1 | \
  docker login --username AWS --password-stdin $ECR_REPO
```

### 4. Push Image

```bash
docker push $ECR_REPO:latest
docker push $ECR_REPO:$(git rev-parse --short HEAD)
```

### 5. Deploy to ECS

The Terraform configuration automatically creates the ECS service. To force a new deployment:

```bash
aws ecs update-service \
  --cluster $(terraform -chdir=terraform output -raw ecs_cluster_name) \
  --service $(terraform -chdir=terraform output -raw ecs_service_name) \
  --force-new-deployment \
  --region us-east-1
```

### 6. Wait for Deployment

```bash
aws ecs wait services-stable \
  --cluster $(terraform -chdir=terraform output -raw ecs_cluster_name) \
  --services $(terraform -chdir=terraform output -raw ecs_service_name) \
  --region us-east-1
```

## Post-Deployment

### 1. Verify Deployment

```bash
# Check service status
aws ecs describe-services \
  --cluster $(terraform -chdir=terraform output -raw ecs_cluster_name) \
  --services $(terraform -chdir=terraform output -raw ecs_service_name) \
  --region us-east-1

# Check task status
aws ecs list-tasks \
  --cluster $(terraform -chdir=terraform output -raw ecs_cluster_name) \
  --service-name $(terraform -chdir=terraform output -raw ecs_service_name) \
  --region us-east-1
```

### 2. View Logs

```bash
aws logs tail $(terraform -chdir=terraform output -raw cloudwatch_log_group) \
  --follow \
  --region us-east-1
```

### 3. Test Health Endpoint

Get the task's public IP and test:

```bash
# Get task IP
TASK_ARN=$(aws ecs list-tasks \
  --cluster $(terraform -chdir=terraform output -raw ecs_cluster_name) \
  --service-name $(terraform -chdir=terraform output -raw ecs_service_name) \
  --query 'taskArns[0]' \
  --output text \
  --region us-east-1)

# Get task details
aws ecs describe-tasks \
  --cluster $(terraform -chdir=terraform output -raw ecs_cluster_name) \
  --tasks $TASK_ARN \
  --region us-east-1

# Test health endpoint (use the public IP from above)
curl http://<task-public-ip>:3000/health
```

## Rollback Procedures

### Rollback to Previous Image

```bash
# Update service to use previous image tag
aws ecs update-service \
  --cluster $(terraform -chdir=terraform output -raw ecs_cluster_name) \
  --service $(terraform -chdir=terraform output -raw ecs_service_name) \
  --task-definition <previous-task-definition-arn> \
  --force-new-deployment \
  --region us-east-1
```

### Rollback Infrastructure Changes

```bash
cd terraform

# Restore previous state
terraform state pull > current.tfstate
# Copy previous state backup
cp terraform.tfstate.backup terraform.tfstate

# Apply previous configuration
terraform apply
```

## Automated Deployment via GitHub Actions

Once GitHub Actions is configured:

1. Push to `main` branch triggers automatic deployment
2. Pull requests trigger tests and Terraform plan
3. Monitor deployment in Actions tab

## Troubleshooting

### Task Fails to Start

```bash
# Check task stopped reason
aws ecs describe-tasks \
  --cluster $(terraform -chdir=terraform output -raw ecs_cluster_name) \
  --tasks <task-id> \
  --query 'tasks[0].stoppedReason' \
  --region us-east-1
```

### Image Pull Errors

- Verify ECR permissions
- Check task execution role has ECR access
- Ensure image exists in ECR

### Secrets Access Issues

- Verify Secrets Manager permissions
- Check secret ARN in task definition
- Ensure secret exists in correct region

## Security Checklist

- [ ] API keys stored in Secrets Manager
- [ ] IAM roles follow least privilege
- [ ] Security groups restrict unnecessary access
- [ ] VPC properly configured
- [ ] Logging enabled
- [ ] Image scanning enabled on ECR
- [ ] HTTPS/TLS configured (if using ALB)

## Maintenance

### Regular Tasks

1. **Weekly**: Review CloudWatch logs and metrics
2. **Monthly**: Update dependencies and base images
3. **Quarterly**: Review and optimize costs
4. **As Needed**: Scale based on usage patterns

### Updates

To update the application:

1. Make code changes
2. Build new image
3. Push to ECR with new tag
4. Update ECS service
5. Verify deployment
6. Monitor for issues

## Cost Optimization

- Use Fargate Spot for non-critical workloads
- Right-size task CPU and memory
- Set appropriate log retention periods
- Clean up unused ECR images
- Use Reserved Instances for predictable workloads
