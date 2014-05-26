#!/bin/bash

source `which github-common`
source `which github-authorization`

## github version
VERSION="0.0.1"

## output usage
usage () {
  echo "usage: github [-hV] <command> [args]"
}

## main
github () {
  local arg=""
  local cmd=""

  ## parse opts
  case "${1}" in

    ## flags
    -V|--version)
      echo "${VERSION}"
      return 0
      ;;

    -h|--help)
      usage
      return 0
      ;;

    *)
      if [ -z "${1}" ]; then
        usage
        return 1
      fi

      ## aliases
      case "${1}" in
        auth)
          arg="authorization"
          ;;

        *)
          arg="${1}"
      esac

      cmd="github-${arg}"
      shift
      if type -f "${cmd}" > /dev/null 2>&1; then
        "${cmd}" "${@}"
        return $?
      fi
      ;;
  esac
  return 0
}

## export
if [[ ${BASH_SOURCE[0]} != $0 ]]; then
  export -f github
else
  github "${@}"
  exit $?
fi
