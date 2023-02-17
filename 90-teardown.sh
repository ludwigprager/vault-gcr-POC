#!/usr/bin/env bash

set -eu
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $BASEDIR

source set-env.sh

#./30-tf-vault/90-destroy.sh
#./30-cli-vault/90-destroy.sh
./25-tf-gcp/90-destroy.sh
./20-tf-backend/90-destroy.sh | true

docker-compose down

SA_NAME="poc-vault-installer"
SA_EMAIL=${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com

#test [[ gcloud iam service-accounts describe ${SA_EMAIL} > /dev/null 2>&1 ]] || \
gcloud iam service-accounts delete --quiet $SA_EMAIL > /dev/null 2>&1 | true


./print-console-links.sh

