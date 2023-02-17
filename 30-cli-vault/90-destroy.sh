#!/usr/bin/env bash

set -eu
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $BASEDIR

source ../functions.sh
source ../set-env.sh


vault secrets disable gcp/ | true
vault auth disable lupra/ | true
vault auth disable userpass/ | true

vault auth disable approle/ | true

