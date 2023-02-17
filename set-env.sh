#!/usr/bin/env bash

# 1. specify the project id that GCP generated for your project
export CLOUDSDK_CORE_PROJECT="g1-01-355707"

export PROJECT_ID=${CLOUDSDK_CORE_PROJECT}

# we create a bucket with the same name as the project-id
BUCKET_LOCATION="europe-west1"
BUCKET_NAME=celp-poc-vault-gcr-${CLOUDSDK_CORE_PROJECT}

#SERVICE_ACCOUNT="celp-sandbox-sit"
#SERVICE_ACCOUNT="sa215735083"

export VAULT_ADDR=$(get-vault-address)
export VAULT_TOKEN=$(get-vault-token)
#export UNSEAL_KEY=$(get-unseal-key)
