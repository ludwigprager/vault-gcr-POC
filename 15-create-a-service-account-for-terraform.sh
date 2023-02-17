#!/usr/bin/env bash

set -eu

: '
THIS=$0

usage() {
cat << EOF
Usage: ${THIS} "<service account name>"
example:

${THIS} terraform-test-6

EOF
}


if [[ $# -lt 1 ]]; then
  usage
  exit 1
fi

SA_NAME=$1
'

SA_NAME="poc-vault-installer"
SA_EMAIL=${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com

gcloud iam service-accounts describe ${SA_EMAIL} > /dev/null 2>&1 && exit 0


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

source set-env.sh

PROJECT_ID=$CLOUDSDK_CORE_PROJECT

# https://cloud.google.com/docs/authentication/production#command-line
gcloud iam service-accounts create ${SA_NAME} \
  --project ${PROJECT_ID}


# https://cloud.google.com/iam/docs/understanding-roles#app-engine-roles
# https://stackoverflow.com/questions/65661144/getting-error-while-allowing-accounts-and-roles-in-terraform-for-gcp

ROLES=""

# roles für terraform (TODO: welche können noch weg?)
ROLES="$ROLES roles/storage.admin"
ROLES="$ROLES roles/iam.roleViewer"
ROLES="$ROLES roles/iam.roleAdmin"
ROLES="$ROLES roles/iam.securityAdmin"

# roles für 'create-a-gke-cluster-with-cli':
ROLES="$ROLES roles/compute.viewer"
ROLES="$ROLES roles/compute.securityAdmin"
ROLES="$ROLES roles/compute.networkAdmin"
ROLES="$ROLES roles/compute.admin"
ROLES="$ROLES roles/container.clusterAdmin"
ROLES="$ROLES roles/container.developer"
ROLES="$ROLES roles/iam.serviceAccountUser"
ROLES="$ROLES roles/storage.objectAdmin"
ROLES="$ROLES roles/storage.objectViewer"
ROLES="$ROLES roles/iap.tunnelResourceAccessor"
ROLES="$ROLES roles/iam.serviceAccountUser"
ROLES="$ROLES roles/networkmanagement.admin"

ROLES=""

ROLES="$ROLES roles/iam.serviceAccountAdmin"
ROLES="$ROLES roles/storage.admin"
ROLES="$ROLES roles/storage.objectAdmin"
ROLES="$ROLES roles/iam.serviceAccountKeyAdmin"

#ROLES="$ROLES roles/storage.legacyBucketOwner"

for role in $ROLES; do
  gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member="serviceAccount:${SA_EMAIL}" \
    --role="${role}" > /dev/null
done


KEY_FILE=./key-file/${SA_NAME}.${PROJECT_ID}.json

gcloud iam service-accounts keys create ${KEY_FILE} \
  --iam-account=${SA_EMAIL}

#echo export GOOGLE_APPLICATION_CREDENTIALS=$(realpath ${KEY_FILE})
echo gcloud iam service-accounts delete ${SA_EMAIL}


# https://serverfault.com/questions/1058611/access-to-the-google-cloud-storage-bucket
