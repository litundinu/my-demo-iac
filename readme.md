# 🚀 AWS Fargate + ECR + ALB + WAF (Terraform, No Modules)

This repository provisions a **containerized web application** on AWS using **Terraform**  
and automates deployment with **GitHub Actions (OIDC authentication)**.

---

## ✅ What’s Included

### 🌐 Networking
- VPC with **public** and **private** subnets  
- Internet Gateway for public access  
- NAT Gateway for private subnet egress  

### 🔒 Security
- Security Groups for ALB and ECS tasks  
- **AWS WAFv2** attached to the ALB with managed rule sets (see below)  

### 🖥️ Compute
- ECS Cluster (Fargate launch type)  
- ECS Task Definition & ECS Service  
- CloudWatch Logs for ECS tasks  

### 📦 Container Registry
- Amazon ECR Repository  
- Lifecycle policy for image cleanup  

### ⚖️ Load Balancing
- Application Load Balancer (ALB)  
- Target Group & Listener (port 80, HTTP)  

### 👤 IAM
- `ecsTaskExecutionRole` → Pull images from ECR + send logs to CloudWatch  
- `ecsTaskRole` → Runtime permissions for app containers  
- `github-deploy` role → Trusts GitHub OIDC to allow CI/CD deployments  

---

## 🛡️ WAF Rules

The WAF (Web Application Firewall) is attached to the ALB.  
It protects the application by filtering malicious traffic using **AWS Managed Rule Sets**.

### 1. Common Rule Set
- **Name**: `AWS-AWSManagedRulesCommonRuleSet`  
- **Priority**: `1`  
- **Purpose**: Blocks broad categories of common web exploits.  
- **Covers**:  
  - Cross-Site Scripting (XSS)  
  - Local File Inclusion (LFI)  
  - PHP Injection attacks  
  - Other common patterns  
- **Action**: Block malicious request patterns.

---

### 2. Known Bad Inputs
- **Name**: `AWS-AWSManagedRulesKnownBadInputsRuleSet`  
- **Priority**: `2`  
- **Purpose**: Detects and blocks requests with suspicious or malformed input.  
- **Covers**:  
  - Malicious request payloads  
  - Exploit signatures  
  - Protocol anomalies  
- **Action**: Block dangerous inputs.

---

### 3. Amazon IP Reputation List
- **Name**: `AWS-AWSManagedRulesAmazonIpReputationList`  
- **Priority**: `3`  
- **Purpose**: Blocks traffic from IPs with a history of malicious activity.  
- **Covers**:  
  - Botnets  
  - Spam sources  
  - AWS-curated bad IP list  
- **Action**: Block requests from high-risk IPs.

---

### 4. SQL Injection Protection
- **Name**: `AWS-AWSManagedRulesSQLiRuleSet`  
- **Priority**: `4`  
- **Purpose**: Protects against SQL Injection attempts.  
- **Covers**:  
  - SQL injection payloads in query parameters  
  - Suspicious SQL keywords and expressions in requests  
- **Action**: Block SQL injection attempts.

---

## 📊 Logging & Monitoring

- **CloudWatch Logs** enabled for ECS tasks and WAF  
- WAF logs stored in a dedicated log groups

- **Sensitive fields redacted** before logging:  
  - `authorization` header  
  - (extendable to other fields such as `password`)  

---