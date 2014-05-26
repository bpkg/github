#!/bin/bash

source `which github-common`

## output usage
usage () {
  echo "usage: github-init [-h]"
  echo "   or: github-init <directory>"
}

## main
github_init () {
  local dir="${1}"

  for opt in ${@}; do
    case "${opt}" in
      -h|--help)
        usage
        return 0
        ;;

    esac
  done

  dir=${dir:-${GH_DIR}}

  if test -d "${dir}"; then
    return 1
  fi

  if [ -z "${dir}" ]; then
    usage
    return 1
  fi

  mkdir -p "${dir}"

  if [ "0" = "$?" ]; then
    echo "Initialized \`${dir}'"
  fi

  return $?
}

## export
if [[ ${BASH_SOURCE[0]} != $0 ]]; then
  export -f github_init
else
  github_init "${@}"
  exit $?
fi
