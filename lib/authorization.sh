#!/bin/bash

source `which github-common`

## output usage
usage () {
  echo "usage: github-authorization [-h]"
  echo "   or: github-authorization <username> [password]"
}

## main
github_authorization () {
  local let use_oauth=0
  local user=""
  local pass=""
  local cflags=""
  local cargs=""
  local token=""

  for opt in ${@}; do
    case "${opt}" in
      -h|--help)
        usage
        return 0
        ;;

      -a|--oauth)
        use_oauth=1
        ;;
    esac
  done

  if [ "-" != "${1:0:1}" ]; then
    user="${1}"
    shift
  fi

  if [ "-" != "${1:0:1}" ]; then
    pass="${1}"
    shift
  fi

  ## curl flags
  cflags="-sLu"

  ## curl args
  if [ -z "${pass}" ]; then
    cargs="${user}"
  else
    cargs="${user}:${pass}"
  fi

  ## try getting a token with basic auth
  github request POST '/authorizations' "${cflags} ${cargs} -d '{ \
    \"description\":    \"bpkg/github(1) authentication\",        \
    \"client_id\":      \"${GH_CLIENT_ID}\",                      \
    \"client_secret\":  \"${GH_CLIENT_SECRET}\"                   \
  }'" | github json -b | {
    while read -r buf; do
      ## read key
      key="$(echo ${buf} | awk '{ print $1 }' | tr -d '\[\"]' | tr ',' '.' )"
      val="$(echo ${buf} | awk '{$1=""; print $0 }' | tr -d '\"')"

      ## trim
      val="$(echo ${val} | sed -e 's/^ *//' -e 's/ *$//')"
      key="$(echo ${key} | sed -e 's/^ *//' -e 's/ *$//')"

      case "${key}" in
        message|error)
          echo >&2
          echo >&2 "  error: ${val}"
          return 1
          ;;

        token)
          token="${val}"
          github token set ${token}
          echo ${token}
          return $?
          ;;
      esac
    done
  }

  return $?
}

## export
if [[ ${BASH_SOURCE[0]} != $0 ]]; then
  export -f github_authorization
else
  github_authorization "${@}"
  exit $?
fi
