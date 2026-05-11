#!/usr/bin/env bash

# Fuzzy pick a remote branch and add it as a worktree.
# Run from any worktree within the repo.

git fetch --all --prune || { echo "Error: Failed to fetch."; exit 1; }

wt_parent=$(dirname "$(git rev-parse --git-common-dir)")

branch=$(git branch -r \
  | grep -v 'HEAD' \
  | sed 's|[[:space:]]*origin/||' \
  | sort -u \
  | fzf --prompt="worktree branch> ")

[[ -z "$branch" ]] && exit 0

dir="$wt_parent/$branch"

if [[ -d "$dir" ]]; then
  echo "Error: Worktree '$dir' already exists."
  exit 1
fi

git worktree add "$dir" "origin/$branch" || {
  echo "Error: Failed to create worktree."
  exit 1
}

command -v zoxide &>/dev/null && zoxide add "$dir"

echo "Created worktree at $dir"
