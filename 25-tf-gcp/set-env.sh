#!/usr/bin/env bash

POC_REGION="europe-west1"
#PROJECT_ID=sandbox-sit-cf1a4


#export TF_VAR_project_id=${CLOUDSDK_CORE_PROJECT}
export TF_VAR_project_id=${PROJECT_ID}
export TF_VAR_region=${POC_REGION}

export TF_VAR_address=$VAULT_ADDR
export TF_VAR_token=$VAULT_TOKEN
