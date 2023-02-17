#!/usr/bin/env bash

set -eu
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $BASEDIR

source ../functions.sh
source ../set-env.sh


# https://developer.hashicorp.com/vault/tutorials/getting-started/getting-started-policies


#vault auth list | grep 'approle/'
#vault auth enable approle
#
#vault write auth/approle/role/my-role \
#    secret_id_ttl=10m \
#    token_num_uses=10 \
#    token_ttl=20m \
#    token_max_ttl=30m \
#    secret_id_num_uses=40 \
#    token_policies=my-policy
##!/usr/bin/env bash

# https://developer.hashicorp.com/vault/tutorials/auth-methods/approle

#vault auth enable approle


# https://gist.github.com/greenbrian/5be10eb2c978a153a52caa9fadbc3b9c

# Creates a role named authproxy with user policy attached.
#vault write auth/approle/role/authproxy \
#  token_policies="user" \
#  token_ttl=1h \
#  token_max_ttl=4h

# read RoleID
vault read auth/approle/role/authproxy/role-id
ROLE_ID=$(vault read -format=json auth/approle/role/authproxy/role-id | jq -r '.data.role_id')

# generate SecretID (CLI)
vault write -force auth/approle/role/authproxy/secret-id
SECRET_ID=$(vault write -f -format=json auth/approle/role/authproxy/secret-id | jq -r '.data.secret_id')

#vault write auth/approle/login \
#  role_id=$ROLE_ID \
#  secret_id=$SECRET_ID

token=$(vault write -format=json auth/approle/login \
  role_id=$ROLE_ID \
  secret_id=$SECRET_ID \
  | jq -r '.auth.client_token' )

#echo $token

vault login $token

./30-access-token.sh $token
