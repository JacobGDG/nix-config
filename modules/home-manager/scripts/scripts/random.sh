#!/usr/bin/env bash

# https://owasp.org/www-community/password-special-characters
owaspCharset='A-Za-z0-9!"#$%&'\''()*+,-./:;<=>?@[\]^_`{|}~'
base64Charset="A-Za-z0-9+/="

function help() {
cat << EOF >&2
  Usage: ${0##*/} [-hfs] [LENGTH]"

  Generate a random string of LENGTH characters.

  Options:"
    -h              Show this help message"
    -f (default)    Including the OWASP recommended characters"
    -s              Use Simple base(Sixty)4 characters (A-Z, a-z, 0-9, +, /)"
    -v              Verbose output"
EOF
}

function log() {
  if [[ $verbose -eq 1 ]]; then
    echo "$1" 1>&2
  fi
}

function error() {
  echo "Error: $1" 1>&2
  exit 1
}

vervose=0

OPTIND=1
while getopts hfsv opt; do
    case $opt in
      h)
        help
        exit 0
        ;;
      f)
        full=1
        ;;
      s)
        simple=1
        ;;
      v)
        verbose=1
        ;;
      *)
        help
        exit 1
        ;;
    esac
done
shift "$((OPTIND-1))"   # Discard the options and sentinel --

# https://www.reddit.com/user/atoponce/comments/186u5li/password_length_recommendations/
length=${1:-16}

if [[ $length -lt 1 ]]; then
  error "Length must be a positive integer"
  exit 1
fi

charset=""

if [[ $full ]]; then
  charset=$owaspCharset
elif [[ $simple ]]; then
  charset=$base64Charset
else
  charset=$owaspCharset
fi

log "Using charset: $charset"

password=$(LC_ALL=C tr -dc "$charset" </dev/random | head -c $length)

entropy="$(password_entropy $password)"

log "Password entropy: $entropy bits"

if [[ $entropy -lt 80 ]]; then
  echo "WARNING!!! Password entropy is low. Consider using a longer password or a different character set." 1>&2
fi

log
echo $password
