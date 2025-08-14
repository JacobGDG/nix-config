#!/usr/bin/env bash

# bit entropy = log2(total character set) * length
# assumptions:
# - a single lowercase is 26 characters
# - a single uppercase is 26 characters
# - a single digit is 10 characters
# - TBC on symbols (maybe +=/ are their own set to complete base64)

function help() {
cat << EOF >&2
  Usage: ${0##*/} [-h] [PASSWORD]
EOF
}

function error() {
  echo "Error: $1" 1>&2
  exit 1
}

function log2() {
  echo $1 | awk '{print log($1)/log(2)}'
}

if [[ -p /dev/stdin ]]; then
  stdin="$(cat -)"
fi

arg="$1"

if [[ "$arg" == "-h" || "$arg" == "--help" ]] || [[ -z "$arg" && -z "$stdin" ]]; then
  help
  exit 0
fi

if [[ -n "$arg" && -n "$stdin" ]]; then
  error "Please provide either a password as an argument or via stdin, not both."
  help
  exit 1
fi

password="${arg:-$stdin}"

charsetLength=0

# TODO: replace this with a process of removing characters so we can see what is
# not accounted for.

if [[ "$password" =~ [a-z] ]]; then
  charsetLength=$((charsetLength + 26))
fi
if [[ "$password" =~ [A-Z] ]]; then
  charsetLength=$((charsetLength + 26))
fi
if [[ "$password" =~ [0-9] ]]; then
  charsetLength=$((charsetLength + 10))
fi
# base64 symbols
if [[ "$password" =~ [+=/] ]]; then
  charsetLength=$((charsetLength + 3))
fi
# SHIFT + numbers
if [[ "$password" =~ [!\"£$%^\&*()_] ]]; then
  charsetLength=$((charsetLength + 11))
fi
# # rest of the common symbols
# # ,./;'#[]<>?:@~{}
# if grep -q 'a[,./;'"'"'#\[\]<>?:@~{}]' <<< "$password"; then
#   echo "sdfasdfasfd"
#   charsetLength=$((charsetLength + 12))
# fi

characterSetBitEntropy=$(log2 "$charsetLength")
passwordLength=${#password}

echo "$(echo "$characterSetBitEntropy * $passwordLength" | bc -l)"
