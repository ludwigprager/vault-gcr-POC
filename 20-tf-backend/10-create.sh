#!/usr/bin/env bash

set -eu
set -o pipefail

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $BASEDIR

source ../functions.sh
source ../set-env.sh

source ./functions.sh

if bucket-exists "${BUCKET_NAME}"  ; then 
  echo bucket ${BUCKET_NAME} already exists
else
  echo creating bucket ${BUCKET_NAME}
  gsutil mb -c regional -l ${BUCKET_LOCATION} gs://${BUCKET_NAME}
fi
