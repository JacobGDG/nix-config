#!/usr/bin/env bash

# https://owasp.org/www-community/password-special-characters
owaspCharset='A-Za-z0-9!"#$%&'\''()*+,-./:;<=>?@[\]^_`{|}~'
base64Charset="A-Za-z0-9+/="
alphanumericCharset="A-Za-z0-9"
numericCharset="0-9"

function help() {
cat << EOF >&2
Usage: ${0##*/} [-hfs] [LENGTH]"

Generate a random string of LENGTH characters.

Options:"
  -h              Show this help message"
  -f (default)    Including the OWASP recommended characters"
  -b              Use Base64 characters (A-Z, a-z, 0-9, +, /)"
  -v              Verbose output"
  -a              Use only alphanumeric characters (A-Z, a-z, 0-9)"
  -n              Use only number characters"
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

verbose=0
charset=""

OPTIND=1
while getopts hfbvan opt; do
    case $opt in
      h)
        help
        exit 0
        ;;
      f)
        charset=$owaspCharset
        ;;
      b)
        if [[ -z $charset ]]; then
          charset=$base64Charset
        else
          error "Cannot use multiple character sets at the same time."
        fi
        ;;
      a)
        if [[ -z $charset ]]; then
          charset=$alphanumericCharset
        else
          error "Cannot use multiple character sets at the same time."
        fi
        ;;
      n)
        if [[ -z $charset ]]; then
          charset=$numericCharset
        else
          error "Cannot use multiple character sets at the same time."
        fi
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

if [[ -z $charset ]]; then
  charset=$owaspCharset
fi

log "Using charset: $charset"

password=$(LC_ALL=C tr -dc "$charset" </dev/random | head -c $length)

entropy="$(password_entropy $password)"

log "Password entropy: $entropy bits"

if [[ $entropy -lt 80 ]]; then
  echo "WARNING!!! Password entropy, $entropy bits, is low. Consider using a longer password or a different character set." 1>&2
fi

log
echo $password
