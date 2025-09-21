#!/usr/bin/env bash

set -uo pipefail

hook_dir="$(cd "$(dirname "$0")" && pwd)"
args=(hook-impl --hook-type=pre-commit --hook-dir="$hook_dir")
exit_code=0

function run-pre-commit() {
  local configFile="$1"
  shift
  if type pre-commit &>/dev/null; then
    pre-commit "${args[@]}" --config="${configFile}" -- "$@" || exit_code=$?
  else
    echo 'pre-commit not found.' 1>&2
    exit 1
  fi
}

if [ -f "$HOME/.config/pre-commit/pre-commit-config.yaml" ]; then
  run-pre-commit "$HOME/.config/pre-commit/pre-commit-config.yaml" "$@"
fi

if [ -f .pre-commit-config.yaml ]; then
  run-pre-commit .pre-commit-config.yaml "$@"
fi

if [ -e ./.git/hooks/pre-commit ]; then
  ./.git/hooks/pre-commit "$@"
fi

exit $exit_code
