# Recipe Rater

## General Overview
Recipe-rater is a cloud-native application platform demonstrating modern DevOps practices, infrastructure automation, and GitOps principles. Originally developed on a self hosted GitLab docker container to leverage its powerful CI/CD options that are useful in the project.

Working on this project was exciting because it centers around something I love (food). Recipe Rater
is an app that lets you look through a bunch of recipes and rate them.

## Architecture Diagram
![Architecture Diagram](./Architecture%20Diagram/Portfolio.drawio.png)
![Architecture Diagram](./Architecture%20Diagram/Screenshot%20from%202024-02-20%2005-14-28.png)

## Repository Structure

This project is organized into three main components:

```
./
├── reciperater/
├── portfolio-gitops/
├── Infra/
└── README.md
```

##  Main Project Features

### Infrastructure Automation
- **AWS CLOUD** main cloud provider
- **Private EKS Cluster** with production-grade security
- **VPC-native networking** with custom subnet configurations
- **Terraform modules** for infrastructure management

### CI/CD Pipeline (Jenkins + Self-Hosted GitLab)
- Automated build and deployment processes
- Container image management
- Semantic versioning automation
- E2E testing integration
- Artifact management with Amazon Elastic Container Registry(ECR)

### GitOps Implementation and Deployment
- ArgoCD implementation using App of Apps pattern
- Helm chart management for all components
- Automated certificate management
- Comprehensive logging and monitoring stack
- Infrastructure-grade ingress control

## Platform Components

### Core Infrastructure
- Amazon EKS Cluster
- VPC Configuration including NAT Gateway
- IAM Policy Setup
- Node Pool Management

### Security & Access
- Cluster Configuration
- Sealed Secrets
- Cert-Manager
- Custom Firewall Rules
- RBAC Management

### Observability Stack
- **Logging**: Elasticsearch, Fluentd, Kibana
- **Monitoring**: Prometheus, Grafana
- **Alerting**: AlertManager
- **Ingress**: NGINX Ingress Controller

## Development Workflow

1. **Infrastructure Updates**
   ```bash
   cd Infra/
   terraform init
   terraform validate
   terraform plan
   terraform apply
   ```

2. **Application Deployment**
   - Push changes to Self Hosted GitLab repository
   - Jenkins pipeline automatically triggers
   - Container images built and pushed to Artifact Registry
   - ArgoCD syncs new configurations

3. **Configuration Management**
   - Update Helm charts in gitops-config
   - ArgoCD automatically detects and applies changes
   - Monitor deployment status through ArgoCD UI

##  Technology Stack

### Cloud & Infrastructure
- AWS Cloud Platform
- Terraform
- Elastic Kubernetes Service
- Elastic Container Registry

### CI/CD & Version Control
- Jenkins
- Docker
- Helm
- GitLab
- ArgoCD

### Monitoring & Logging
- Prometheus
- Grafana
- Elasticsearch
- Fluentd
- Kibana

## Security Features

- IAM
- Secure VPC
- Sealed Secrets
- TLS Encryption
- RBAC Configurations

## Monitoring & Logging

- Centralized logging with EFK stack
- Metric collection with Prometheus
- Custom Grafana dashboards
- Automated alerting
- Performance monitoring

## Getting Started

### Prerequisites
- AWS Account
- GitLab Account
- Jenkins Server
- kubectl and Helm installed
- Terraform >= 1.0

### Initial Setup
1. Clone the repository
2. Configure AWS credentials
3. Initialize Terraform
4. Deploy infrastructure
5. Configure GitLab integration
6. Deploy ArgoCD
7. Apply GitOps configurations

## Documentation

Detailed documentation for each component can be found in their respective directories:
- [Infrastructure Setup]()
- [Application Documentation](./reciperater/README.md)
- [GitOps Configuration]()

---