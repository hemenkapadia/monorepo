# Terraform Infrastructure Management

This repository contains Terraform configurations for managing infrastructure across multiple cloud providers and virtualization platforms. The structure is designed to support multiple environments and organizations using Terraform workspaces.

## Directory Structure

### `/environments/` Directory

The `environments/` directory contains environment-specific configurations that define how infrastructure is deployed for different environments (dev, staging, prod) and platforms (kvm, aws, azure, gcp).

**Purpose:**

- **Environment Isolation**: Each environment (dev, staging, prod) has its own configuration
- **Platform-Specific Deployments**: Different platforms (kvm, aws, etc.) are organized separately
- **Organization-Specific Settings**: Each environment can support multiple organizations using workspaces as detailed below.
- **State Management**: Terraform Workspaces are used for per organization/environment state management.

**Structure:**

```bash
environments/
├── dev/
│   └── kvm/                            # Local KVM virtualization for development
│       ├── main.tf                     # Main infrastructure configuration
│       ├── variables.tf
│       ├── terraform.org_name.tfvars   # Org specific variable values
│       ├── backend.tf
│       ├── terraform.tfstate.d         # Org specific tfstate
│           └── org-a/ 
│               ├── terraform.tfstate   # Terraform state for org-a dev environment
│       └── cloud_init/                 # Cloud-init configuration files
├── staging/
│   └── aws/                            # AWS cloud for staging
└── prod/
    └── aws/                            # AWS cloud for production
```

### `/modules/` Directory

The `modules/` directory contains reusable Terraform modules that encapsulate common infrastructure patterns and resources.

**Purpose:**

- **Reusability**: Common infrastructure patterns are defined once and reused
- **Consistency**: Ensures consistent resource creation across environments
- **Maintainability**: Changes to infrastructure patterns are centralized
- **Abstraction**: Complex resource configurations are abstracted into simple interfaces

**Available Modules:**

#### KVM Modules (`/modules/kvm/`)

- **`cluster/`**: Creates a cluster of KVM virtual machines
- **`domain/`**: Manages individual KVM domains (VMs)
- **`network/`**: Creates and manages KVM networks
- **`storage/`**: Creates and manages KVM storage pools
- **`volume/`**: Creates and manages KVM volumes

#### Cloud Provider Modules (`/modules/aws/`, `/modules/azure/`, `/modules/gcp/`)

- Provider-specific modules for cloud resources
- Organized by service type (compute, networking, storage, etc.)

## Using Terraform Workspaces for Multi-Organization Management

Terraform workspaces allows managing multiple sets of infrastructure resources using the same configuration files. This is useful for creating distinct infrastructure for different organizations within the same environment, e.g. distinct Dev environments for Org-A and Org-B.

### Creating Organization-Specific Workspaces

#### Navigate to the Environment Directory

```bash
cd environments/dev/kvm
```

#### Initialize Terraform (if not already done)

```bash
terraform init
```

#### Organization-Specific Configuration

Each organization should have its own `terraform.org_name.tfvars` file to set organization-specific values.

Create separate tfvars files for each organization:

```bash
# For Organization A, create file and update with variable values
vi terraform.org-a.tfvars

# For Organization B, create file and update with variable values
vi terraform.org-b.tfvars
```

Edit each file with organization-specific values:

**terraform.org-a.tfvars:**

```hcl
# Organization A specific configuration
org_name = "org-a"
org_network_address_cidr = ["192.168.100.0/24"]
cluster_node_name_prefix = "org-a-k8s"
cluster_node_count = 3
```

**terraform.org-b.tfvars:**

```hcl
# Organization B specific configuration  
org_name = "org-b"
org_network_address_cidr = ["192.168.200.0/24"]
cluster_node_name_prefix = "org-b-k8s"
cluster_node_count = 2
```

### Deploying Infrastructure for Different Organizations

The `terraform-org-deploy.sh` script is a helper tool designed to simplify deploying, planning, or destroying Terraform-managed infrastructure for a specific organization within an environment.

- **Takes two arguments:** the organization name (e.g., `org-a`) and the action to perform (`plan`, `apply`, or `destroy`). If the action is not specified, it defaults to `plan`.
- **Checks for the required tfvars file:** It ensures that a variable file named `terraform.<org_name>.tfvars` exists for the specified organization. This file contains organization-specific configuration values.
- **Initializes and selects the correct workspace:** The script checks if a Terraform workspace for the organization exists. If it does, it selects it; if not, it creates a new workspace for that organization. This ensures that each organization's resources and state are isolated.
- **Runs the specified Terraform action:** Depending on the action argument, it runs `terraform plan`, `terraform apply`, or `terraform destroy` using the organization's tfvars file and workspace.

#### Deploy for organizations A and B

```bash
# Format: terraform-org-deploy.sh org_name action
terraform-org-deploy org_a apply
```

```bash
# Format: terraform-org-deploy.sh org_name action
terraform-org-deploy org_b apply
```

#### Check Current Workspace

```bash
terraform workspace show
```

#### View Resources for Current Organization

```bash
# Switch to the organization's workspace
terraform workspace select org_a

# Show terraform state for this organization
terraform state list
```

#### Destroy Resources for Specific Organization

```bash
# Switch to the organization's workspace
terraform workspace select org_a

# Destroy resources
terraform-org-deploy org_a destroy
```

### Best Practices for Multi-Organization Management

1. **Naming Convention**: Use consistent naming patterns for workspaces (e.g., `{org-name}-{environment}`)
2. **State Isolation**: Each workspace maintains separate state, ensuring complete isolation between organizations
3. **Configuration Management**: Use separate tfvars files or environment variables for each organization
4. **Resource Naming**: Ensure resource names include organization identifiers to avoid conflicts
5. **Network Isolation**: Use different CIDR blocks for each organization's networks
6. **Documentation**: Maintain clear documentation of which workspaces belong to which organizations

### Example Workflow

```bash
# 1. Initialize Terraform
terraform init

# 2. Create workspaces for different organizations
terraform workspace new acme-corp-dev
terraform workspace new beta-inc-dev

# 3. Deploy infrastructure for ACME Corp
terraform workspace select acme-corp-dev
terraform-org-deploy.sh acme-corp-dev apply

# 4. Deploy infrastructure for Beta Inc
terraform workspace select beta-inc-dev  
terraform-org-deploy.sh beta-inc-dev apply

# 5. Verify deployments
terraform workspace list
terraform workspace select acme-corp-dev
terraform state list

# 6. Destroy infrastructure for ACME Corp
terraform workspace select acme-corp-dev
terraform-org-deploy.sh acme-corp-dev destroy

# 7. Destroy infrastructure for Beta Inc
terraform workspace select beta-inc-dev  
terraform-org-deploy.sh beta-inc-dev destroy
```

### Troubleshooting

#### State Conflicts

```bash
# Check current workspace
terraform workspace show

# Ensure you're in the correct workspace before applying changes
terraform workspace select {correct-workspace}
```

#### Avoid Resource Conflicts

Follow these guidelines to avoid resource conflicts

- Ensure each organization uses unique resource names
- Use different CIDR blocks for networks
- Verify organization-specific variables are set correctly

This approach provides complete isolation between organizations while maintaining the flexibility to use the same infrastructure patterns and modules across all deployments.
