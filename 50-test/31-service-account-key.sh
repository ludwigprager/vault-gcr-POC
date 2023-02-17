#!/usr/bin/env bash

set -eu
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $BASEDIR

source ../functions.sh
source ../set-env.sh

vault auth list
vault policy list
vault secrets list

token=$(vault read -format json gcp/static-account/my-key-account/key)

echo $token | jq -r '.data.private_key_data'
key=$(echo $token | jq -r '.data.private_key_data')

echo $token > token.json
echo $key > key.json

cat key.json  | base64 -d > key.decoded.json
cat key.decoded.json  | docker login -u _json_key --password-stdin https://gcr.io

