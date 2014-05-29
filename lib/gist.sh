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
    get)
      github request GET /gists/${1}
      ;;

    list)
      github request GET /gists/public
      ;;

    starred)
      github request GET /gists/starred
      ;;

    list-commits)
      github request GET /gists/${1}/commits
      ;;

    star)
      github request PUT /gists/${1}/star
      ;;

    unstar)
      github request DELETE /gists/${1}/star
      ;;

    check-star)
      github request GET /gists/${1}/star
      ;;

    fork)
      github request POST /gists/${1}/forks
      ;;

    list-forks)
      github request GET /gists/${1}/forks
      ;;

    delete)
      github request DELETE /gists/${1}
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
