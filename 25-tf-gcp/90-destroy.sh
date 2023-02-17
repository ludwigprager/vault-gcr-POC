#!/usr/bin/env bash

set -eu

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $BASEDIR

source ../functions.sh
source ../set-env.sh
source ./set-env.sh

terraform init \
  -input=false \
  -backend-config="bucket=${BUCKET_NAME}"

terraform destroy -auto-approve
