#!/bin/bash

source `which github-common`

UP=$'\033[A'
DOWN=$'\033[B'
PAT=0          # Personal access token
OAUTH2=1       # OAuth2

selected=$PAT
auth_options=()
auth_options[$PAT]="Personal access token"
auth_options[$OAUTH2]="OAuth2(ClientId+ClientSecret)"

## output usage
usage () {
  echo "usage: github-authorization [-h]"
  echo "   or: github-authorization <username> [password]"
}

## switch the auth options
switch_auth_option () {
  let "selected = !${selected}"
}

## display the auth options
display_auth_option () {
  echo
  echo "  Select your auth type:"
  echo
  for i in {0..1}; do
    local desc=${auth_options[$i]}
    if test "$i" = "$selected"; then
      printf "  \033[36mο\033[0m $desc\033[0m\n"
    else
      printf "    \033[90m$desc\033[0m\n"
    fi
  done
  echo
}

## main
github_authorization () {
  local let use_oauth=0
  local user=""
  local pass=""
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

  ## check `git init` has been runned
  if ! test -d "${GH_DIR}"; then
    abort `github init` required
  fi

  ## check and store input
  if [ "-" != "${1:0:1}" ]; then
    user="${1}"
    shift
  fi

  if [ "-" != "${1:0:1}" ]; then
    pass="${1}"
    shift
  fi

  clear
  display_auth_option $selected

  while true; do
    read -s -n 3 c
    case "$c" in
      $UP|$DOWN)
        clear
        switch_auth_option
        display_auth_option 
        ;;
      *)
        clear
        break
        ;;
    esac
  done

  ## curl args
  if [ -z "${pass}" ]; then
    cargs="${user}"
  else
    cargs="${user}:${pass}"
  fi

  case "$selected" in
    $OAUTH2)
      if [ -z "${GH_CLIENT_ID}" ]; then
        abort "Environment variable \`GH_CLIENT_ID' is not set"
      fi
      if [ -z "${GH_CLIENT_SECRET}" ]; then
        abort "Environment variable \`GH_CLIENT_SECRET' is not set"
      fi
      ;;
    $PAT)
      if [ -z "${GH_PERSONAL_TOKEN}" ]; then
        abort "Environment variable \`GH_PERSONAL_TOKEN' is not set"
      else
        github token set ${GH_PERSONAL_TOKEN}
        echo
        log user ${user}
        log token ${GH_PERSONAL_TOKEN}
        echo
        return $?
      fi
      ;;
    *)
      abort "Unknown authorization type"
      ;;
  esac

  ## try getting a token with basic auth
  github request POST '/authorizations' "-u ${cargs} -d '{ \
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
          abort "${val}"
          ;;

        token)
          token="${val}"
          github token set ${token}
          log user ${user}
          log token ${token}
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
