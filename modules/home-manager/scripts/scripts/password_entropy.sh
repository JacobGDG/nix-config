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
Options:"
  -h              Show this help message"
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

function log2() {
  echo $1 | awk '{print log($1)/log(2)}'
}

verbose=0

OPTIND=1
while getopts hv opt; do
    case $opt in
      h)
        help
        exit 0
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

length=${#password}
password_calc=$(echo $password | sed 's/[a-z]//g')
if [[ $length -gt ${#password_calc} ]]; then
  charsetLength=$((charsetLength + 26))
fi
length=${#password_calc}
password_calc=$(echo $password_calc | sed 's/[A-Z]//g')
if [[ $length -gt ${#password_calc} ]]; then
  charsetLength=$((charsetLength + 26))
fi
length=${#password_calc}
password_calc=$(echo $password_calc | sed 's/[0-9]//g')
if [[ $length -gt ${#password_calc} ]]; then
  charsetLength=$((charsetLength + 10))
fi
length=${#password_calc}
password_calc=$(echo $password_calc | sed 's/[+=\/]//g')
if [[ $length -gt ${#password_calc} ]]; then
  charsetLength=$((charsetLength + 3))
fi
length=${#password_calc}
password_calc=$(echo $password_calc | sed 's/[!\"£$%^\&*()_]//g')
if [[ $length -gt ${#password_calc} ]]; then
  charsetLength=$((charsetLength + 11))
fi
# length=${#password_calc}
# password_calc=$(echo $password_calc | sed 's/[,\-.\/;#\[\]<>?:@~{}]//g')
# if [[ $length -gt ${#password_calc} ]]; then
#   charsetLength=$((charsetLength + 11))
# fi

if [[ ${#password_calc} -gt 0 ]]; then
  log "Characters not accounted for: $(echo $password_calc | grep -o . | sort -u | tr -d '\n')"
fi

characterSetBitEntropy=$(log2 "$charsetLength")
passwordLength=${#password}
entropy=$(echo "entropy=$characterSetBitEntropy * $passwordLength; scale=0; entropy/1" | bc -l)


echo $entropy
