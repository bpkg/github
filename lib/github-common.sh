#!/bin/bash

## Log <type> <msg>
log () {
  printf "  \033[36m%10s\033[0m : \033[90m%s\033[0m\n" $1 $2
}

## abort
abort () {
  printf "\n  \033[31mError: $@\033[0m\n\n" && exit 1
}

## export
if [[ ${BASH_SOURCE[0]} != $0 ]]; then

  export GH_API_URL=${GH_API_URL:=https://api.github.com}
  export GH_AUTH_URL=${GH_AUTH_URL:-${GH_API_URL}/user}
  export GH_DIR="${GH_DIR:-${HOME}/.gh}"
  export GH_TOKEN_PATH="${GH_TOKEN_PATH:-${GH_DIR}/token}"
  export GH_TOKEN="${GH_TOKEN:-$(
    test -f ${GH_TOKEN_PATH} && cat ${GH_TOKEN_PATH} | head -n1
  )}"
  export log
  export abort

fi
