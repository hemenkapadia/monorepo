terraform {
  backend "local" {
    path = "backend/tf_local_backend.tfstate"
  }
}