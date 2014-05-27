#!/bin/bash

source `which github-common`

## output usage
usage () {
  echo "usage: github-gist [-h] <op>"
  return 0
}

## main
github_gist () {
  local op="${1}"
  shift

  ## sure root directory exists
  if ! test -d "${GH_DIR}"; then
    return 1
  fi

  case "${op}" in
    list)
      github request GET /gists/public
      ;;

    starred)
      github request GET /gists/starred
      ;;

    -h|--help)
      usage
      ;;

    *)
      usage
      return 1
      ;;
  esac

  return $?
}

## export
if [[ ${BASH_SOURCE[0]} != $0 ]]; then
  export -f github_gist
else
  github_gist "${@}"
  exit $?
fi
