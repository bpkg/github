#!/bin/bash

source `which github-common`

## output usage
usage () {
  return 0
}

## main
github_request () {
  declare -a local args=()
  local method=""
  local uri=""
  local cargs=""
  local url=""
  local token=""
  local let show_raw=0

  method="${1}"
  shift
  uri="${1}"
  shift

  ## pass the rest to curl
  cargs="${@}"

  ## read token
  token="$(github token get)"

  ## if found then append to uri
  if [ ! -z "${token}" ]; then
    if [[ ${uri} = *\?* ]]; then
      uri+='\&'
    else
      uri+="?"
    fi

    uri+="access_token=${token}"
  else
    cargs+=" -n "
  fi

  ## build url
  if [ "/" = "${uri:0:1}" ]; then
    url="${GH_API_URL}${uri}"
  else
    url="${GH_API_URL}/${uri}"
  fi

  ## curl args
  cargs+=" -sL"

  ## build command
  cmd="curl -X "${method}" ${url} "${cargs}""

  ## trim
  cmd="$(echo "${cmd}" | tr -d '\n')"

  ## request
  ( eval "${cmd}" )
  return $?
}

## export
if [[ ${BASH_SOURCE[0]} != $0 ]]; then
  export -f github_request
else
  github_request "${@}"
  exit $?
fi
