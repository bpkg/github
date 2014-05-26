#!/bin/bash

## output usage
usage () {
  echo "usage: github-events [-h]"
  echo "   or: github-events"
  echo "   or: github-events <user|org>"
  echo "   or: github-events <user|org>/<repo> [-n|--network] [-o|--org]"
  return 0
}

## main
github_events () {
  return 0
}

## export
if [[ ${BASH_SOURCE[0]} != $0 ]]; then
  export -f github_events
else
  github_events "${@}"
  exit $?
fi
