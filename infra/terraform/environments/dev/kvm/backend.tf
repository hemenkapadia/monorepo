terraform {
  # The backend "local" block is intentionally left empty here.
  # Workspace will create per workspace (org) backend directory under terraform.tfstate.d directory
  # As a sideeffect an empty backend directory will be created in this location
  backend "local" {}
}