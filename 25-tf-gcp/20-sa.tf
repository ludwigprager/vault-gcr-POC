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

/*
resource "google_project_iam_binding" "k3d-vault-gcr-binding" {
  project = data.google_project.project.project_id
  role = "projects/${data.google_project.project.project_id}/roles/${google_project_iam_custom_role.vault-gcp.role_id}"
  members = [
    "serviceAccount:${google_service_account.k3d-vault-gcr.email}"
  ]
} 
*/

/*
resource "google_project_iam_binding" "project" {
  project    = var.project_id
  role = "roles/${google_project_iam_custom_role.vault-gcp.role_id}"
  #role = "projects/${data.google_project.project.project_id}/roles/${google_project_iam_custom_role.vault-gcp.role_id}"

  members  = ["serviceAccount:${google_service_account.k3d-vault-gcr.email}"]
}
*/


/*
resource "google_service_account" "vm-ccd3-c645d-vault" {
  account_id   = "vm-ccd3-c645d-vault"
  display_name = "urspruenglich: vm-ccd3-c645d-vault"
}
*/



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


/*
resource "google_service_account" "gitlab-gce-registry" {
  account_id = "gitlab-gce-registry"
  project    = var.project_id
}
*/


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

/*
    "iam.serviceAccountKeys.delete",
    "iam.serviceAccountKeys.get",
    "iam.serviceAccountKeys.list"
  {
    "resource": {
      "google_service_account_iam_member": {
        "gitlab-gce-registry_ffc510dfb5b4e0f5f23b2180b4909abb": {
          "member": "serviceAccount:${google_service_account.vm-ccd3-c645d-vault.email}",
          "role": "${google_project_iam_custom_role.vault-gcp.id}",
          "service_account_id": "${google_service_account.gitlab-gce-registry.name}"
        }
      }
    }
  },
*/

/*
resource "google_service_account_iam_member" "gitlab-gce-registry_ffc510dfb5b4e0f5f23b2180b4909abb" {
  member = "serviceAccount:${google_service_account.vm-ccd3-c645d-vault.email}"
  role = "${google_project_iam_custom_role.vault-gcp.id}"
  service_account_id = "${google_service_account.gitlab-gce-registry.name}"
}
*/


/*
  {
    "resource": {
      "google_service_account_iam_member": {
        "gitlab-gce-registry_ffc510dfb5b4e0f5f23b2180b4909abb": {
          "member": "serviceAccount:${google_service_account.vm-ccd3-c645d-vault.email}",
          "role": "${google_project_iam_custom_role.vault-gcp.id}",
          "service_account_id": "${google_service_account.gitlab-gce-registry.name}"
        }
      }
    }
  },
*/



/*
  {
    "resource": {
      "google_storage_bucket_iam_member": {
        "control-center-dev-337811_049ed219453f72d6b842effcf2d47042": {
          "bucket": "${google_container_registry.control-center-dev-337811.id}",
          "member": "serviceAccount:${google_service_account.gitlab-gce-registry.email}",
          "role": "roles/storage.legacyBucketWriter"
        }
      }
    }
  },
*/

/*
  {
    "resource": {
      "vault_gcp_secret_static_account": {
        "gitlab-gce-registry": {
          "backend": "${vault_gcp_secret_backend.gcp.path}",
          "secret_type": "access_token",
          "service_account_email": "${google_service_account.gitlab-gce-registry.email}",
          "static_account": "gitlab-gce-registry",
          "token_scopes": [
            "https://www.googleapis.com/auth/cloud-platform",
            "https://www.googleapis.com/auth/plus.me"
          ]
        }
      }
    }
  },
*/

/*
  {
    "resource": {
      "vault_jwt_auth_backend_role": {
        "gitlab-gce-registry": {
          "backend": "${vault_jwt_auth_backend.gitlab.path}",
          "bound_audiences": [
            "https://gitlab.celp.net"
          ],
          "bound_claims": {
            "namespace_path": "financial-services/infrastructure/apps,financial-services/infrastructure/images,financial-services/infrastructure/vendor"
          },
          "role_name": "gitlab-gce-registry",
          "role_type": "jwt",
          "token_policies": [
            "control-center-dev-337811-gitlab-gce-registry"
          ],
          "user_claim": "user_email"
        }
      }
    }
  },
*/


/*
  {
    "resource": {
      "vault_policy": {
        "gitlab-gce-registry": {
          "name": "control-center-dev-337811-gitlab-gce-registry",
          "policy": "{\n    \"path\": [\n        {\n            \"gcp/static-account/gitlab-gce-registry/token\": {\n                \"capabilities\": [\n                    \"read\"\n                ]\n            }\n        }\n    ]\n}"
        }
      }
    }
  },
*/

/*
resource "vault_policy" "gitlab-gce-registry" {
  name = "control-center-dev-337811-gitlab-gce-registry"
  policy = "{\n    \"path\": [\n        {\n            \"gcp/static-account/gitlab-gce-registry/token\": {\n                \"capabilities\": [\n                    \"read\"\n                ]\n            }\n        }\n    ]\n}"
}
*/

