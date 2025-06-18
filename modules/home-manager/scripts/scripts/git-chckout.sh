#!/usr/bin/env bash

function help {
  echo "Git checkout script, pass a branch to check it out."
  echo "If no branch is provided, it will prompt to select a branch using fzf."
  echo "Usage: git-checkout [branch:optional]"
}

echo "Arguments"
echo "here: $@"

if [[ $# -eq 0 ]]; then
  git branch --format='%(refname:short)' | fzf --height 40% --reverse --border --prompt='Select a branch: ' | xargs git checkout
fi

if [[ $1 == "help" ]]; then
  help
  exit 0
fi

git checkout "$@"
