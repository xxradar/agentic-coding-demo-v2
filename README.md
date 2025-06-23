# DevOps Future NG - Production EKS Infrastructure 🚀

[![Terraform](https://img.shields.io/badge/Terraform-1.0+-623CE4?logo=terraform)](https://terraform.io)
[![AWS EKS](https://img.shields.io/badge/AWS-EKS%201.32-FF9900?logo=amazon-aws)](https://aws.amazon.com/eks/)
[![Production Ready](https://img.shields.io/badge/Production-Ready-green)](https://github.com/xxradar/agentic-coding-demo-v2)

This repository contains **production-grade AWS EKS infrastructure** implemented with Terraform, featuring comprehensive logging, monitoring, and security best practices. Built using **agentic coding** principles for maintainable and scalable cloud infrastructure.

> 🎯 **Fully deployed and tested** - This infrastructure has been successfully deployed and verified in AWS `us-west-2`

## 🌟 Key Features

- ✅ **Production-Ready**: Fully tested EKS v1.32 infrastructure
- 🔒 **Security First**: Least-privilege IAM, envelope encryption, network isolation
- 📊 **Comprehensive Logging**: VPC Flow Logs + EKS control plane logging to CloudWatch
- 🏗️ **Modular Design**: Reusable Terraform modules for VPC and EKS
- 🚀 **Automated Deployment**: One-command infrastructure deployment
- 📱 **High Availability**: Multi-AZ deployment across 3 availability zones
- 📚 **Complete Documentation**: Deployment guides, troubleshooting, and runbooks

## Architecture Overview

- **VPC**: Custom VPC with public/private subnets across 3 AZs
- **EKS Cluster**: Kubernetes 1.32+ with managed node groups
- **Security**: Network security groups, IAM roles, and envelope encryption
- **High Availability**: Multi-AZ deployment with NAT gateways
- **Comprehensive Logging**: VPC Flow Logs and EKS control plane logging
- **Monitoring**: CloudWatch logging for network and cluster monitoring

## Prerequisites

1. **AWS CLI** configured with appropriate credentials
2. **Terraform** >= 1.0 installed
3. **kubectl** for cluster management
4. Appropriate AWS permissions for EKS, VPC, IAM, and KMS resources

## Quick Start

### 1. Clone and Navigate
```bash
cd /Users/xxradar/testing/devopsfuture2
```

### 2. Initialize Terraform
```bash
terraform init
```

### 3. Review Configuration
```bash
terraform plan
```

### 4. Deploy Infrastructure
```bash
terraform apply
```

### 5. Configure kubectl
After deployment completes, configure kubectl using one of these methods:

**Option A: Use AWS CLI**
```bash
aws eks --region us-west-2 update-kubeconfig --name devops-future-ng-cluster
```

**Option B: Use generated kubeconfig**
```bash
export KUBECONFIG=/Users/xxradar/testing/devopsfuture2/kubeconfig.yaml
```

### 6. Verify Cluster
```bash
kubectl get nodes
kubectl get pods --all-namespaces
```

## Configuration

### Default Variables
- **Region**: us-west-2
- **Account ID**: 974654858447
- **Cluster Version**: 1.32
- **Node Groups**: 3 managed node groups with t3.medium instances
- **Capacity**: 3 desired nodes (1 per AZ), 6 max, 3 min

### Customization
Modify `variables.tf` or create a `terraform.tfvars` file:

```hcl
# terraform.tfvars
cluster_version = "1.32"
node_group_instance_types = ["t3.large"]
node_group_desired_size = 6
```

## Infrastructure Components

### VPC Module (`modules/vpc/`)
- VPC with DNS support enabled
- 3 public subnets for load balancers
- 3 private subnets for worker nodes
- Internet Gateway for public access
- NAT Gateways for private subnet outbound access
- Route tables for proper traffic routing
- **VPC Flow Logs** for comprehensive network monitoring
- **CloudWatch Log Groups** with appropriate retention

### EKS Module (`modules/eks/`)
- EKS cluster with managed control plane
- IAM roles for cluster and node groups
- Security groups with least-privilege access
- 3 managed node groups (one per AZ)
- KMS encryption for secrets
- Essential add-ons: CoreDNS, kube-proxy, VPC CNI, EBS CSI

## Security Features

1. **Network Security**
   - Private subnets for worker nodes
   - Security groups with minimal required access
   - VPC isolation

2. **IAM Security**
   - Dedicated service roles for cluster and nodes
   - Minimal required permissions
   - AWS managed policies where appropriate

3. **Encryption**
   - KMS encryption for Kubernetes secrets
   - Built-in envelope encryption for EKS 1.28+

4. **Logging & Monitoring**
   - VPC Flow Logs for comprehensive network traffic monitoring
   - CloudWatch logs for all EKS control plane components
   - Audit logging enabled for security compliance
   - Dedicated log groups with appropriate retention policies

## Outputs

The deployment provides these useful outputs:
- VPC and subnet information
- EKS cluster details (endpoint, ARN, security groups)
- kubeconfig file location
- kubectl configuration command

## Cleanup

To destroy the infrastructure:
```bash
terraform destroy
```

## Troubleshooting

### Common Issues

1. **Insufficient Permissions**
   - Ensure AWS credentials have EKS, VPC, IAM, and KMS permissions

2. **Region Availability**
   - Verify EKS 1.32 is available in us-west-2
   - Check instance type availability in target AZs

3. **Node Group Issues**
   - Verify sufficient EC2 capacity in region
   - Check instance type quotas

### Useful Commands

```bash
# Check cluster status
aws eks describe-cluster --region us-west-2 --name devops-future-ng-cluster

# List node groups
aws eks list-nodegroups --region us-west-2 --cluster-name devops-future-ng-cluster

# View cluster logs
aws logs describe-log-groups --log-group-name-prefix /aws/eks/devops-future-ng-cluster
```

## Cost Optimization

- Uses t3.medium instances by default (suitable for development)
- Single NAT Gateway per AZ (can be reduced to 1 for cost savings)
- On-demand instances (consider spot instances for non-production)

## Next Steps

After deployment:
1. Install additional cluster tools (Helm, ingress controllers)
2. Set up CI/CD pipelines
3. Configure monitoring and alerting
4. Implement backup strategies
5. Set up additional security policies

## Support

For issues or questions:
- Review Terraform plan output
- Check AWS CloudTrail for permission issues
- Consult AWS EKS documentation
- Verify resource quotas and limits
