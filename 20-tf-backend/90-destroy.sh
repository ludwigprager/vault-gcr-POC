#!/usr/bin/env bash

set -eu
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $BASEDIR

source ../functions.sh
source ../set-env.sh

source ./functions.sh

if bucket-exists "${BUCKET_NAME}"; then 
  echo deleting bucket ${BUCKET_NAME}
  gsutil rb gs://$BUCKET_NAME
else
  echo "bucket ${BUCKET_NAME} doesn't exist"
fi

