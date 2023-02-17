#!/usr/bin/env bash

set -eu
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $BASEDIR

source ../functions.sh
source ../set-env.sh

STATIC_ACCOUNT_NAME=k3d-vault-gcr
STATIC_ACCOUNT_EMAIL=${STATIC_ACCOUNT_NAME}@${PROJECT_ID}.iam.gserviceaccount.com

gcloud iam service-accounts keys create ${STATIC_ACCOUNT_NAME}.json --iam-account=$STATIC_ACCOUNT_EMAIL
