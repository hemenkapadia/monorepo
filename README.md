# Modern Cloud-Native Application Monorepo

This repository serves as a template and learning project for building a complete cloud-native application using modern DevOps practices and tools. It demonstrates how to structure a monorepo containing multiple application components with independent build cycles while maintaining deployment cohesion.

## Repository Structure

```
monorepo/
│
├── infra/                    # Base cloud infrastructure setup
│   ├── packer/               # Packer scripts for building images
│   │   ├── image-1/          # Packer scripts for building image-1
│   │   └── README.md         # Documentation for Packer usage
│   ├── terraform/            # Infrastructure-as-Code (Terraform scripts)
│   │   ├── modules/          # Reusable Terraform modules
│   │   ├── environments/     # Environment-specific configurations (dev/staging/prod)
│   │   └── main.tf           # Entry point for Terraform
│   └── README.md             # Documentation for infrastructure setup
│
├── cicd/                     # CI/CD configurations
│   ├── github-actions/       # GitHub Actions workflows
│   │   └── workflows/        # YAML files for workflows
│   ├── selective-build.sh    # Script for selective builds based on file changes
│   └── README.md             # Documentation for CI/CD setup
│
├── helm/                     # Helm chart for Kubernetes deployment
│   ├── Chart.yaml            # Helm chart metadata
│   ├── templates/            # Kubernetes YAML templates
│   ├── values.yaml           # Default configuration values
│   └── README.md             # Documentation for Helm usage
│
├── apps/                     # Application components
│   ├── component-1/          # Example application component
│   │   ├── src/              # Application source code
│   │   ├── Dockerfile        # Dockerfile for building the container
│   │   ├── tests/            # Unit and integration tests
│   │   ├── build.sh          # Custom build script
│   │   └── README.md         # Component-specific documentation
│   ├── component-2/          # Another application component
│   │   ├── src/              
│   │   ├── Dockerfile        
│   │   ├── tests/            
│   │   ├── build.sh          
│   │   └── README.md         
│   └── README.md             # General guidelines for application components
│
├── docs/                     # Project documentation
│   ├── architecture.md       # High-level architecture design
│   ├── dev-guide.md          # Developer guidelines
│   ├── contributing.md       # Contribution guidelines
│   └── README.md             # Overview of the monorepo
│
├── scripts/                  # Utility scripts
│   ├── setup.sh              # Script to set up local environment
│
└── README.md                 # Root-level documentation
```

## Getting Started

1. Clone the repository
2. Run `./scripts/setup.sh` to set up the local environment
