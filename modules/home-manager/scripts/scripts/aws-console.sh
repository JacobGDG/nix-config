#!/usr/bin/env bash

set -uoe pipefail

function help {
  echo "Script to quickly open AWS console given a local aws profile"
  echo "Usage: aws-console <profile>"
}

if [[ $# -eq 0 || $# -ne 1 || $1 == "help" ]]; then
  help
  exit 1
fi

caller_json=$(aws --profile "$1" sts get-caller-identity --output json)
account_id=$(echo "$caller_json" | jq -r '.Account')
url="https://healios-portal.awsapps.com/start/#/console?account_id=$account_id&role_name=AWSAdministratorAccess"

echo "Opening URL:"
echo $url

if command -v xdg-open >/dev/null 2>&1; then
  xdg-open "$url" >/dev/null 2>&1 || echo "Failed to auto-open browser. Copy the URL above into your browser."
elif command -v open >/dev/null 2>&1; then
  open "$url" >/dev/null 2>&1 || echo "Failed to auto-open browser. Copy the URL above into your browser."
else
  echo "No supported browser opener found (xdg-open or open). Copy the URL above into your browser."
fi
