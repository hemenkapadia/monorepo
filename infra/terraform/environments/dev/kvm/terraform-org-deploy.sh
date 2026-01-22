#!/usr/bin/env bash
set -euo pipefail

ORG="$1"
ACTION="${2:-plan}"   # default action is 'apply' if not provided

TFVARS_FILE="terraform.${ORG}.tfvars"

# Ensure org-specific tfvars exists
if [[ ! -f "$TFVARS_FILE" ]]; then
    echo "ERROR: Missing vars file for org '$ORG' -> $TFVARS_FILE"
    exit 1
fi

echo ">>> Using organization: $ORG"
echo ">>> Terraform action: $ACTION"
echo ">>> Vars file: $TFVARS_FILE"

# Init with per-org state path
# terraform workspace list fails if terraform init is not done for the first time
#terraform init -reconfigure \
#  -backend-config="path=${BACKEND_DIR}/${ORG}.tfstate"

# Select or create workspace
if terraform workspace list | grep -qE "^\*? *${ORG}\$"; then
    echo ">>> Switching to existing workspace $ORG"
    terraform workspace select "$ORG" >/dev/null
else
    echo ">>> Creating new workspace $ORG"
    terraform workspace new "$ORG" >/dev/null
fi

# Run Terraform action
case "$ACTION" in
  plan)
    terraform plan -var="org_name=${ORG}" -var-file="$TFVARS_FILE"
    ;;
  apply)
    terraform apply -auto-approve -var="org_name=${ORG}" -var-file="$TFVARS_FILE"
    ;;
  destroy)
    terraform destroy -auto-approve -var="org_name=${ORG}" -var-file="$TFVARS_FILE"
    ;;
  *)
    echo "ERROR: Unknown action '$ACTION'. Use plan|apply|destroy"
    exit 1
    ;;
esac
