#!/bin/bash

source `which github-common`

github_token () {
  local op="${1}"
  shift

  ## sure root directory exists
  if ! test -d "${GH_DIR}"; then
    return 1
  fi

  case "${op}" in
    set)
      ## nothing to set ?
      if [ -z "${1}" ]; then
        return 1
      fi

      ## purge
      rm -f "${GH_DIR}/token"
      touch "${GH_DIR}/token"

      echo "${@}" >> "${GH_DIR}/token"
      ;;

    get)
      if ! test -f "${GH_DIR}/token"; then
        return 1
      fi

      cat "${GH_DIR}/token" | xargs echo -n
      ;;

    *) return 1 ;;
  esac

  return $?
}

## export
if [[ ${BASH_SOURCE[0]} != $0 ]]; then
  export -f github_token
else
  github_token "${@}"
  exit $?
fi
