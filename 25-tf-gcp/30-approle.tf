
# https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/auth_backend
resource "vault_auth_backend" "approle" {
  type = "approle"
  path = "approle"
}

# https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/approle_auth_backend_role
resource "vault_approle_auth_backend_role" "authproxy" {
  backend        = vault_auth_backend.approle.path
  role_name      = "authproxy"
  token_ttl      = 600
  token_max_ttl  = 3600
  token_policies = ["user"]
}
