#!/usr/bin/env bash

function help {
  echo "Clone a git repo as bare into .git and set up for worktrees"
  echo "Usage: git-clone-wt <url> [name]"
}

if [[ $# -eq 0 || $1 == "help" ]]; then
  help
  exit 1
fi

url="$1"
name="${2:-$(basename "$url" .git)}"

if [[ -d "$name" ]]; then
  echo "Error: Directory '$name' already exists."
  exit 1
fi

mkdir -p "$name" || { echo "Error: Failed to create directory '$name'."; exit 1; }

git clone --bare "$url" "$name/.git" || {
  echo "Error: Failed to clone repository."
  rm -rf "$name"
  exit 1
}

cd "$name" || exit 1

git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"

git fetch --all || { echo "Error: Failed to fetch remote branches."; exit 1; }

default=$(git symbolic-ref --short HEAD)

git worktree add "$default" || {
  echo "Error: Failed to create worktree for '$default'."
  exit 1
}

command -v zoxide &>/dev/null && zoxide add "$PWD/$default"

echo "Ready at $PWD/$default"
