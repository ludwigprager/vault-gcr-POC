# WARNING
This is a POC. Usage of `terraform apply -auto-approve` is disputable in production environments.

# Usage TL;DR
```
git clone https://github.com/ludwigprager/vault-gcr-POC.git
cd vault-gcr-POC/
```
Specify your `project id` in [./set-env.sh](./set-env.sh#5)
```
export CLOUDSDK_CORE_PROJECT="g1-01-355707 "
```
The following command starts all components and runs a few tests:
```
./10-deploy.sh
```
while this call in turn removes all created resources:
```
./90-teardown.sh
```

# About This POC
This POC
- starts a hashicorp vault in dev-mode in a docker container. See the [docker compose file](./docker-compose.yaml).  
- creates required resources in GCP: registry, service accounts
- deploys resources in the vault: 'approle' auth engine, policies, the 'gcp secrets engine'
- finally, runs a test including
    - authentication with approle
    - acquiring a SecretID, then an access-token
    - login into vault with the access-token
    - gets a gcp oauth2-token
    - logs into the gcp registry with the oauth2-token
- Directory [20-tf-backend](./20-tf-backend) manages the backend statefile
- Directory [25-tf-gcp](./25-tf-gcp) contains terraform code to create resources in GCP and the local vault.
- Directory [50-test](./50-test) contains scripts with basic tests.
- Use scripts starting with `10-` to build resources while `90-` scripts remove those resources.


## All shell scripts
- can be called from arbitrary working directories.
- are idempotent
- exit on error


## Debug Commands
### Gain Access To Vault
By running
```
source ./functions.sh
source ./set-env.sh
```
the shell variables `$VAULT_ADDR` and `$VAULT_TOKEN` will be set.  
Verify with:
```
echo $VAULT_ADDR
echo $VAULT_TOKEN 
```
### Run The Acceptance Test
```
 ./50-test/20-approle-login.sh 
```
On success you see a `Login Succeeded` at the bottom of a long output.

### Read A 'RoleID'
```
vault read auth/approle/role/authproxy/role-id
```
Result:
```
Key        Value
---        -----
role_id    40c72d64-c0d5-cfb9-7fdc-885455bd000b
```

### Read A 'SecretID'
```
vault write -force auth/approle/role/authproxy/secret-id
```
Result:
```
Key                   Value
---                   -----
secret_id             12d54604-c602-8bf9-9a13-7baf2f7ac80e
secret_id_accessor    bd1097fa-aadb-dc3b-cd66-74731d04da3a
secret_id_num_uses    0
secret_id_ttl         0s
```

### Read An 'access token' From Vault
```
vault read gcp/static-account/my-key-account/token
```
Result:
```
Key                   Value
---                   -----
expires_at_seconds    1668942289
token                 ya29.c.b0Aa9Vdykn1ilmqSx0V8qaxsnw5fjFKTj3ZaaeX1zknrk51F7cc-oxCK2BbVj-3E6HfX8-8jm9NOqw1dDfrvwnOJ2Ca4ROWHcYb28C1HozIPVSGNHA-F9DmbwbN4slzlVMwW4Xqmvbo31s89keUEhACu-cJC9CkYWnP1C1AVjaxtAqxWDBurGS9J4exKx6LEDXsXPwKz2gMEpGPUThw0RrchDTV3d0zzQ........................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................
token_ttl             59m58s
```

### List 'auth' Backends.
```
vault auth list
```
You should see `approle`
```
Path        Type       Accessor                 Description                Version
----        ----       --------                 -----------                -------
approle/    approle    auth_approle_03f5c7e9    n/a                        n/a
token/      token      auth_token_c106c9cf      token based credentials    n/a
```
### List secret engines.
```
vault secrets list
```
You should see `gcp` listed.
```
Path          Type         Accessor              Description
----          ----         --------              -----------
cubbyhole/    cubbyhole    cubbyhole_eb74262b    per-token private secret storage
gcp/          gcp          gcp_a680dcb9          n/a
identity/     identity     identity_cc5c5f40     identity store
secret/       kv           kv_12894de6           key/value secret storage
sys/          system       system_ef293959       system endpoints used for control, policy and debugging

```


