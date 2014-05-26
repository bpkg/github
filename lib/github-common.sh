#!/bin/bash

## export
if [[ ${BASH_SOURCE[0]} != $0 ]]; then

  export GH_API_URL=${GH_API_URL:=https://api.github.com}
  export GH_AUTH_URL=${GH_AUTH_URL:-${GH_API_URL}/user}
  export GH_DIR="${GH_DIR:-${HOME}/.gh}"
  export GH_TOKEN_PATH="${GH_TOKEN_PATH:-${GH_DIR}/token}"
  export GH_TOKEN="${GH_TOKEN:-$(
    test -f ${GH_TOKEN_PATH} && cat ${GH_TOKEN_PATH} | head -n1
  )}"

fi
