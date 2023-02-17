#!/usr/bin/env bash

set -eu
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $BASEDIR

source ../functions.sh
source ../set-env.sh


# https://developer.hashicorp.com/vault/docs/auth/userpass

# userpass mit default path
vault auth enable userpass

vault write auth/userpass/users/mitchellh \
    password=foo \
    policies=admins

vault login -method=userpass \
    username=mitchellh \
    password=foo

vault auth disable userpass/


# userpass mit path "lupra-userpass"
vault auth   enable -path lupra  userpass 

vault write auth/lupra/users/mitchellh \
    password=foo \
    policies=admins

vault login -method=userpass -path lupra \
    username=mitchellh \
    password=foo

vault auth disable lupra/

