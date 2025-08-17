# 🚀 AWS Fargate + ECR + ALB + WAF (Terraform, No Modules)

This repo provisions a **containerized app** on AWS using **Terraform** and deploys via **GitHub Actions**.

---

## ✅ What’s included

- **Networking**
  - VPC with public + private subnets
  - Internet Gateway + NAT Gateway
- **Security**
  - Security groups for ALB and ECS
  - WAF attached to ALB (with managed rule sets)
- **Compute**
  - ECS Cluster (Fargate)
  - ECS Task Definition & Service
  - CloudWatch Logs for app
- **Image Registry**
  - ECR Repository (with lifecycle policy)
- **Load Balancer**
  - Application Load Balancer (ALB)
  - Listener + Target Group
- **IAM**
  - `ecsTaskExecutionRole` (pull image + logs)
  - `ecsTaskRole` (runtime app role)
  - `github-deploy` role (OIDC trust for GitHub Actions)