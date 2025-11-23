# Claude Cloud Environment

A comprehensive cloud infrastructure setup for deploying Claude AI applications on AWS using Docker, Terraform, and automated CI/CD pipelines.

## Features

- **Containerized Deployment**: Docker and Docker Compose configuration
- **Infrastructure as Code**: Terraform scripts for AWS ECS/Fargate deployment
- **CI/CD Pipeline**: GitHub Actions workflows for automated testing and deployment
- **Production-Ready**: Includes monitoring, logging, and security best practices
- **Scalable Architecture**: AWS ECS Fargate with auto-scaling capabilities

## Architecture

```
┌─────────────────────────────────────────────────────┐
│                   AWS Cloud                          │
│  ┌───────────────────────────────────────────────┐  │
│  │              VPC (10.0.0.0/16)                │  │
│  │  ┌─────────────────────────────────────────┐  │  │
│  │  │         Public Subnets                   │  │  │
│  │  │  ┌──────────────┐  ┌──────────────┐     │  │  │
│  │  │  │ ECS Fargate  │  │ ECS Fargate  │     │  │  │
│  │  │  │   Task 1     │  │   Task 2     │     │  │  │
│  │  │  └──────────────┘  └──────────────┘     │  │  │
│  │  └─────────────────────────────────────────┘  │  │
│  │                                                │  │
│  │  ┌─────────────┐  ┌──────────────┐           │  │
│  │  │ CloudWatch  │  │   Secrets    │           │  │
│  │  │    Logs     │  │   Manager    │           │  │
│  │  └─────────────┘  └──────────────┘           │  │
│  └───────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────┘
```

## Prerequisites

- Node.js 20 or higher
- Docker and Docker Compose
- AWS CLI configured with appropriate credentials
- Terraform 1.0 or higher
- Anthropic API key

## Quick Start

### Local Development

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd claude-cloud-environment
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Set up environment variables:
   ```bash
   cp .env.example .env
   # Edit .env and add your ANTHROPIC_API_KEY
   ```

4. Run locally:
   ```bash
   npm start
   ```

5. Access the application at `http://localhost:3000`

### Docker Deployment

1. Build and run with Docker Compose:
   ```bash
   docker-compose up -d
   ```

2. Check logs:
   ```bash
   docker-compose logs -f
   ```

3. Stop the containers:
   ```bash
   docker-compose down
   ```

## AWS Deployment

### Prerequisites Setup

1. Create an ECR repository:
   ```bash
   aws ecr create-repository \
     --repository-name claude-cloud-environment \
     --region us-east-1
   ```

2. Create S3 bucket for Terraform state:
   ```bash
   aws s3 mb s3://claude-terraform-state --region us-east-1
   ```

### Infrastructure Provisioning

1. Navigate to the terraform directory:
   ```bash
   cd terraform
   ```

2. Copy and configure variables:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your values
   ```

3. Initialize Terraform:
   ```bash
   terraform init
   ```

4. Review the plan:
   ```bash
   terraform plan
   ```

5. Apply the infrastructure:
   ```bash
   terraform apply
   ```

### Deploy Application

1. Build and push Docker image to ECR:
   ```bash
   # Login to ECR
   aws ecr get-login-password --region us-east-1 | \
     docker login --username AWS --password-stdin <account-id>.dkr.ecr.us-east-1.amazonaws.com

   # Build and tag
   docker build -t claude-cloud-environment .
   docker tag claude-cloud-environment:latest \
     <account-id>.dkr.ecr.us-east-1.amazonaws.com/claude-cloud-environment:latest

   # Push
   docker push <account-id>.dkr.ecr.us-east-1.amazonaws.com/claude-cloud-environment:latest
   ```

2. Update ECS service:
   ```bash
   aws ecs update-service \
     --cluster claude-cluster-prod \
     --service claude-app-service-prod \
     --force-new-deployment
   ```

## CI/CD Pipeline

The project includes GitHub Actions workflows for automated deployment:

### Workflows

1. **Deploy to AWS** (`.github/workflows/deploy.yml`)
   - Triggers on push to main/develop branches
   - Runs tests
   - Builds and pushes Docker image to ECR
   - Deploys to ECS

2. **PR Checks** (`.github/workflows/pr-checks.yml`)
   - Runs on pull requests
   - Lints code
   - Tests Docker build
   - Security scanning with Trivy

### Required GitHub Secrets

Configure these secrets in your GitHub repository:

- `AWS_ACCESS_KEY_ID`: AWS access key
- `AWS_SECRET_ACCESS_KEY`: AWS secret key
- `ANTHROPIC_API_KEY`: Your Anthropic API key
- `ECR_REPOSITORY_URL`: Your ECR repository URL

## API Endpoints

### Health Check
```bash
GET /health
```
Returns application health status.

### Root
```bash
GET /
```
Returns API information and available endpoints.

### Chat Endpoint
```bash
POST /api/chat
Content-Type: application/json

{
  "message": "Your message here"
}
```

## Configuration

### Environment Variables

| Variable | Description | Required | Default |
|----------|-------------|----------|---------|
| `ANTHROPIC_API_KEY` | Anthropic API key | Yes | - |
| `CLAUDE_MODEL` | Claude model version | No | claude-sonnet-4-5-20250929 |
| `NODE_ENV` | Environment (development/production) | No | development |
| `PORT` | Server port | No | 3000 |
| `AWS_REGION` | AWS region | No | us-east-1 |

### Terraform Variables

See `terraform/variables.tf` for all available Terraform variables.

## Monitoring and Logging

- **CloudWatch Logs**: Application logs are sent to CloudWatch Logs
- **ECS Container Insights**: Enabled for cluster monitoring
- **Health Checks**: Automated health checks every 30 seconds

### View Logs

```bash
# Using AWS CLI
aws logs tail /ecs/claude-app-prod --follow

# Using Terraform output
terraform output cloudwatch_log_group
```

## Security

- API keys stored in AWS Secrets Manager
- Non-root container user
- Security group restrictions
- VPC isolation
- Secrets excluded from version control
- Regular security scanning with Trivy

## Scaling

### Manual Scaling

Update the desired count in Terraform:
```hcl
desired_count = 3
```

Then apply:
```bash
terraform apply
```

### Auto Scaling (Future Enhancement)

Add auto-scaling policies based on CPU/memory utilization or custom metrics.

## Troubleshooting

### Common Issues

1. **ECS Task Fails to Start**
   - Check CloudWatch logs for errors
   - Verify environment variables and secrets
   - Ensure security group allows necessary traffic

2. **Docker Build Fails**
   - Check Dockerfile syntax
   - Verify base image availability
   - Review build logs for specific errors

3. **Terraform Apply Fails**
   - Verify AWS credentials
   - Check IAM permissions
   - Review Terraform state

### Debug Commands

```bash
# Check ECS service status
aws ecs describe-services \
  --cluster claude-cluster-prod \
  --services claude-app-service-prod

# View task details
aws ecs describe-tasks \
  --cluster claude-cluster-prod \
  --tasks <task-id>

# Test Docker container locally
docker run -p 3000:3000 \
  -e ANTHROPIC_API_KEY=your_key \
  claude-cloud-environment
```

## Cost Estimation

Approximate monthly AWS costs (us-east-1):

- ECS Fargate (1 task, 0.25 vCPU, 0.5 GB): ~$15
- CloudWatch Logs (10 GB): ~$5
- Data Transfer: Variable
- **Total**: ~$20-30/month (minimal usage)

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

MIT License - see LICENSE file for details

## Support

For issues and questions:
- Open an issue in the GitHub repository
- Check the troubleshooting section
- Review AWS ECS and Terraform documentation

## Roadmap

- [ ] Add auto-scaling policies
- [ ] Implement Application Load Balancer
- [ ] Add multiple environment support (dev/staging/prod)
- [ ] Integrate monitoring dashboard
- [ ] Add backup and disaster recovery
- [ ] Implement blue-green deployment
- [ ] Add API rate limiting
- [ ] Enhanced security with WAF
