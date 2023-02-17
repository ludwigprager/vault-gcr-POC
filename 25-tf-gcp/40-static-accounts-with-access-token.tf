

# https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/gcp_secret_backend
resource "vault_gcp_secret_backend" "gcp" {
  credentials = "${file("../key-file/poc-vault-installer.${var.project_id}.json")}"
}

# https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/gcp_secret_static_account
resource "vault_gcp_secret_static_account" "static_account" {
  service_account_email = "${google_service_account.k3d-vault-gcr.email}"
  secret_type    = "access_token"
  token_scopes   = ["https://www.googleapis.com/auth/cloud-platform"]
  binding {
    resource = "buckets/artifacts.${data.google_project.project.project_id}.appspot.com"

    roles = [
      "roles/storage.objectViewer",
    ]
  }

  backend        = vault_gcp_secret_backend.gcp.path
  static_account = "k3d-vault-gcr"


  depends_on = [
    google_service_account.k3d-vault-gcr,
    module.project-services
  ]

}

