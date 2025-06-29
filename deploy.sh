#!/bin/bash
# Generated by Copilot

set -e

echo "🚀 DevOps Future NG - EKS Deployment Script"
echo "==========================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check prerequisites
check_prerequisites() {
    print_status "Checking prerequisites..."
    
    # Check Terraform
    if ! command -v terraform &> /dev/null; then
        print_error "Terraform is not installed. Please install Terraform first."
        exit 1
    fi
    
    # Check AWS CLI
    if ! command -v aws &> /dev/null; then
        print_error "AWS CLI is not installed. Please install AWS CLI first."
        exit 1
    fi
    
    # Check kubectl
    if ! command -v kubectl &> /dev/null; then
        print_warning "kubectl is not installed. You'll need it to manage the cluster."
    fi
    
    # Check AWS credentials
    if ! aws sts get-caller-identity &> /dev/null; then
        print_error "AWS credentials not configured. Please run 'aws configure' first."
        exit 1
    fi
    
    print_status "Prerequisites check completed ✅"
}

# Initialize Terraform
init_terraform() {
    print_status "Initializing Terraform..."
    terraform init
    print_status "Terraform initialized ✅"
}

# Plan deployment
plan_deployment() {
    print_status "Creating Terraform plan..."
    terraform plan -out=tfplan
    print_status "Terraform plan created ✅"
}

# Deploy infrastructure
deploy_infrastructure() {
    print_status "Deploying infrastructure..."
    print_warning "This will create AWS resources that may incur costs."
    
    read -p "Do you want to proceed? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_status "Deployment cancelled."
        exit 0
    fi
    
    terraform apply tfplan
    print_status "Infrastructure deployed ✅"
}

# Configure kubectl
configure_kubectl() {
    print_status "Configuring kubectl..."
    
    # Get cluster name from Terraform output
    CLUSTER_NAME=$(terraform output -raw cluster_id 2>/dev/null || echo "devops-future_ng-cluster")
    
    # Update kubeconfig
    aws eks --region us-west-2 update-kubeconfig --name "$CLUSTER_NAME"
    
    print_status "kubectl configured ✅"
    
    # Test connection
    print_status "Testing cluster connection..."
    if kubectl get nodes > /dev/null 2>&1; then
        print_status "Cluster connection successful ✅"
        echo
        echo "Node status:"
        kubectl get nodes
    else
        print_warning "Unable to connect to cluster immediately. This is normal for new clusters."
        print_status "Try running 'kubectl get nodes' in a few minutes."
    fi
}

# Show useful information
show_info() {
    echo
    print_status "Deployment completed! 🎉"
    echo
    echo "Useful commands:"
    echo "  kubectl get nodes                    # Check node status"
    echo "  kubectl get pods --all-namespaces   # Check all pods"
    echo "  terraform output                     # Show all outputs"
    echo
    echo "Generated files:"
    echo "  ./kubeconfig.yaml                    # Standalone kubeconfig file"
    echo
    echo "To destroy the infrastructure:"
    echo "  terraform destroy"
    echo
}

# Main execution
main() {
    check_prerequisites
    init_terraform
    plan_deployment
    deploy_infrastructure
    configure_kubectl
    show_info
}

# Run main function
main "$@"
