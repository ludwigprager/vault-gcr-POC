# https://gist.github.com/kawsark/4cdb66093d6206d9e036ecd1294e6509

# Allow managing leases
path "sys/leases/*"
{
  capabilities = ["read", "list"]
}

# Manage auth methods broadly across Vault
path "auth/*"
{
  capabilities = ["read", "list"]
}

# Create, update, and delete auth methods
path "sys/auth/*"
{
  capabilities = ["read", "list"]
}

# List auth methods
path "sys/auth"
{
  capabilities = ["read"]
}

# List existing policies
path "sys/policies/acl"
{
  capabilities = ["read","list"]
}

# Create and manage ACL policies
path "sys/policies/acl/*"
{
  capabilities = ["read","list"]
}

# List, create, update, and delete key/value secrets
path "secret/*"
{
  capabilities = ["read","list"]
}

# Manage secret engines
path "sys/mounts/*"
{
  capabilities = ["read","list"]
}

# List existing secret engines.
path "sys/mounts"
{
  capabilities = ["read"]
}

# Read health checks
path "sys/health"
{
  capabilities = ["read"]
}
