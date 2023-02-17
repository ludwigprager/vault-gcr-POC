#!/usr/bin/env bash

set -eu
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $BASEDIR

docker-compose up -d


#export UNSEAL_KEY=$(docker-compose logs |  sed -n 's/.*Unseal Key: \(.*\)/\1/p')
#export ROOT_TOKEN=$(docker-compose logs |  sed -n 's/.*Root Token: \(.*\)/\1/p')
source ./functions.sh
source ./set-env.sh


#echo unseal key: $UNSEAL_KEY
echo vault root token: $VAULT_TOKEN

./15-create-a-service-account-for-terraform.sh

./20-tf-backend/10-create.sh
./25-tf-gcp/10-apply.sh
#./30-cli-vault/10-apply.sh
#./30-tf-vault/10-apply.sh

./50-test/10-perform-tests.sh

./print-console-links.sh
