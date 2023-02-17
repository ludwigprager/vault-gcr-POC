#!/usr/bin/env bash

usage-remote-exec() {
THIS=${FUNCNAME[1]}
cat << EOF
Usage: ${THIS} "<IP> <KEY> <command>"
example:

${THIS} 1.2.3.4 ls

EOF
}

get-vault-address() {
  local UNSEAL_KEY=$(docker-compose logs |  sed -n 's/.*Unseal Key: \(.*\)/\1/p')

  printf 'http://127.0.0.1:8200'

}
export -f get-vault-address

get-vault-token() {
  local ROOT_TOKEN=$(docker-compose logs |  sed -n 's/.*Root Token: \(.*\)/\1/p')

  if [[ ! -z ${ROOT_TOKEN} ]]; then
    printf ${ROOT_TOKEN}
  fi
}
export -f get-vault-token

get-unseal-key() {
  local UNSEAL_KEY=$(docker-compose logs |  sed -n 's/.*Unseal Key: \(.*\)/\1/p')

  if [[ ! -z ${UNSEAL_KEY} ]]; then
    printf ${UNSEAL_KEY}
  fi
}
export -f get-unseal-key

