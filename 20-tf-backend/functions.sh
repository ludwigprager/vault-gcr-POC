#!/usr/bin/env bash

function bucket-exists() {
  local bucket_name=$1

  result=$(gsutil  ls | grep -Fx gs://${bucket_name}/)
  if [[ "$result" == "gs://${bucket_name}/" ]]; then
    # 0 = true
    return 0 
  else
    # 1 = false
    return 1
  fi

}

export -f bucket-exists
