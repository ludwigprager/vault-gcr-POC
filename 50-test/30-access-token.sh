#!/usr/bin/env bash

set -eu
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $BASEDIR


token=$1

vault login $token

echo vault auth list
echo vault policy list
echo vault secrets list
echo vault list gcp/static-account/

#unset VAULT_TOKEN

#token=$(vault read -format json gcp/static-account/my-key-account/token)
token=$(vault read -format json gcp/static-account/k3d-vault-gcr/token)

echo $token | jq -r '.data.token'
gcrToken=$(echo $token | jq -r '.data.token')

GCR_REGISTRY=https://eu.gcr.io
GCR_REGISTRY=https://gcr.io

set -x

docker login $GCR_REGISTRY -u oauth2accesstoken -p "$gcrToken"
