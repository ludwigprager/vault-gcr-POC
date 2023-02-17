provider "google" {
  project     = var.project_id
  region      = var.region
# version = "~> 1.19.0"
}
provider "vault" {
# address     = var.address
# token      = var.token
}
