#!/usr/bin/env bash

set -eu
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $BASEDIR

source ../functions.sh
source ../set-env.sh

STATIC_ACCOUNT_NAME=k3d-vault-gcr
STATIC_ACCOUNT_EMAIL=${STATIC_ACCOUNT_NAME}@${PROJECT_ID}.iam.gserviceaccount.com

BUCKET=artifacts.${PROJECT_ID}.appspot.com

./createkey.sh

CREDENTIALS=../key-file/poc-vault-installer.${PROJECT_ID}.json
vault secrets enable gcp
vault write gcp/config credentials=@${STATIC_ACCOUNT_NAME}.json

vault write gcp/static-account/my-key-account \
    service_account_email="${STATIC_ACCOUNT_EMAIL}" \
    secret_type="access_token" \
    token_scopes="https://www.googleapis.com/auth/cloud-platform" \
    bindings=-<<EOF
      resource "buckets/artifacts.${PROJECT_ID}.appspot.com" {
        roles = [
          "roles/storage.objectViewer",
        ]
      }
EOF

