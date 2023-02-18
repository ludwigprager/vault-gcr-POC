data "google_project" "project" {}

module "project-services" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 13.0"

  project_id    = var.project_id

  activate_apis = [
    "iam.googleapis.com",
    "containerregistry.googleapis.com",
    "cloudresourcemanager.googleapis.com"
  ]
}


resource "google_service_account" "k3d-vault-gcr" {
  account_id   = "k3d-vault-gcr"
  display_name = "k3d pull from gcr"
}

resource "google_project_iam_member" "k3d-vault-gcr-binding" {
  project = data.google_project.project.project_id
  role = "projects/${data.google_project.project.project_id}/roles/${google_project_iam_custom_role.vault-gcp.role_id}"
  member = "serviceAccount:${google_service_account.k3d-vault-gcr.email}"
} 

resource "google_project_iam_member" "k3d-vault-gcr-binding-storage-admin" {
  project = data.google_project.project.project_id
  role = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.k3d-vault-gcr.email}"
} 

resource "google_project_iam_member" "k3d-vault-gcr-binding-project-iam-admin" {
  project = data.google_project.project.project_id
  role = "roles/resourcemanager.projectIamAdmin"
  member = "serviceAccount:${google_service_account.k3d-vault-gcr.email}"
} 




# https://github.com/terraform-google-modules/terraform-google-project-factory/issues/564
resource "google_container_registry" "my_registry" {
  depends_on = [module.project-services]
# location = "EU"
}

resource "google_storage_bucket_iam_member" "viewer" {
  bucket = google_container_registry.my_registry.id
  role = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.k3d-vault-gcr.email}"
}



resource "google_project_iam_custom_role" "vault-gcp" {
  role_id = "vault_gcp"
  title   = "vault-gcp"
  project = var.project_id

  permissions = [
    "iam.serviceAccounts.get",
    "iam.serviceAccounts.getAccessToken",
    "iam.serviceAccountKeys.create",
  ]

}


