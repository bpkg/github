#!/bin/bash

source `which github-common`

## output usage
usage () {
  echo "usage: github-authorization [-h]"
  echo "   or: github-authorization <username> [password]"
  echo "   or: github-authorization <token> -a|--oauth"
}

## main
github_authorization () {
  local let use_oauth=0
  local user=""
  local pass=""
  local cflags=""
  local cargs=""

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

  ## append oauth part
  if [ "1" = "${use_oauth}" ]; then
    cargs+=":x-oauth-basic"
  fi

  ## build cmd
  cmd="curl ${cflags} ${cargs} "${GH_AUTH_URL}""

  ## request
  ${cmd} | github json -b | {
    while read -r buf; do
      local key=""
      local val=""

      ## read key
      key="$(echo ${buf} | awk '{ print $1 }' | tr -d '\[\"]' | tr ',' '.' )"
      val="$(echo ${buf} | awk '{$1=""; print $0 }' | tr -d '\"')"

      ## trim
      key="$(echo ${key} | sed -e 's/^ *//' -e 's/ *$//')"
      val="$(echo ${val} | sed -e 's/^ *//' -e 's/ *$//')"

      case "${key}" in
        message)
          echo >&2 "  error: ${val}"
          return 1
          ;;

        ## key to look for signaling valid
        ## authentication
        login)
          if [ "1" = "${use_oauth}" ]; then
            echo >&2 "  info: Storing access token"
            github token set "${user}"
          fi
          return $?
          ;;
      esac
    done

    ## consider a failure if reached
    return 1
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
