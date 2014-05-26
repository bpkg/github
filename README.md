github
======

Github API from the command line

## install

```sh
$ [sudo] bpkg install github -g
```

## usage

**cli:**

auth:

```sh
$ github auth jwerle
Enter host password for user 'jwerle':
  info: Storing access token
```

read token:

```sh
$ github token get
cf02301afdsfsbff6b06fdsfsbad2c225fdsfdsf
```

Request feeds with authenticated user:

```sh
$ github request GET /feeds
{
  "timeline_url": "https://github.com/timeline",
  "user_url": "https://github.com/{user}",
  "current_user_public_url": "https://github.com/jwerle",
  "_links": {
    "timeline": {
      "href": "https://github.com/timeline",
      "type": "application/atom+xml"
    },
    "user": {
      "href": "https://github.com/{user}",
      "type": "application/atom+xml"
    },
    "current_user_public": {
      "href": "https://github.com/jwerle",
      "type": "application/atom+xml"
    }
  }
}
```

**script:**

```sh
source `which github`

user="jwerle"

json_parser () {
  while read -r line; do
    echo "${line}" | ## echo line
    github json -b | ## parse
    tr -d '["]'    | ## sanitize
    tr ',' '.'     | ## convert to dot seperators
  done
}

## prompt for password
github auth "${user}"

## bail if auth failed
if (( $? > 0 )); then
  exit $?
fi

## request and render output
{
  ## read feeds and output urls to json parser
  github request GET /feeds | json_parser      |

  ## filter on _links.href and print
  grep _links | grep href | awk '{ print $2 }' |
}

## exit with last return code
exit $?
```

## license

MIT
