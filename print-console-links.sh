#!/usr/bin/env bash

set -eu
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $BASEDIR

source ./functions.sh
source ./set-env.sh

echo
echo "statefile:        https://console.cloud.google.com/storage/browser?project=${PROJECT_ID}"
echo "service accounts: https://console.cloud.google.com/iam-admin/serviceaccounts?project=${PROJECT_ID}"
echo "permissions:      https://console.cloud.google.com/iam-admin/iam?project=${PROJECT_ID}"
#echo "registry:         https://console.cloud.google.com/gcr/images?project=${PROJECT_ID}"
echo
