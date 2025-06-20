#!/usr/bin/env bash

function help {
  echo "Git repository creation script"
  echo "Call this command from a direcotry, as if you were about to call clone, ie within ~/src/"
  echo "Usage: git-repo <repo_name>"
}

function remove_directory {
  local dir="$1"
  if [[ -d "$dir" ]]; then
    echo "Removing existing directory '$dir'."
    rm -rf "$dir" || {
      echo "Error: Failed to remove directory '$dir'."
      exit 1
    }
  fi
}

if [[ $# -eq 0 || $1 == "help" ]]; then
  help
  exit 1
fi

if [[ $# -ne 1 ]]; then
  echo "Error: You must provide exactly one argument, the repository name."
  exit 1
fi

repo_name=$1

# Check repository already exists
if git rev-parse --is-inside-work-tree &>/dev/null; then
  echo "Error: You are already inside a git repository. Please run this command outside of any git repository."
  exit 1
fi

# Check if the directory already exists
if [[ -d "$repo_name" ]]; then
  echo "Error: Directory '$repo_name' already exists."
  exit 1
fi

echo "Creating a new git repository named '$repo_name' in the current directory."

mkdir "$repo_name" || {
  echo "Error: Failed to create directory '$repo_name'."
  exit 1
}

cd "$repo_name" || {
  echo "Error: Failed to change directory to '$repo_name'."
  remove_directory "$repo_name"
  exit 1
}

git init || {
  echo "Error: Failed to initialize a new git repository."
  cd - && remove_directory "$repo_name"
  exit 1
}

touch .gitignore

git add .gitignore
git cm -m "Initial commit"

gh repo create "$repo_name" --public --source=. --remote=origin --push || {
  echo "Error: Failed to create a new GitHub repository."
  cd - && remove_directory "$repo_name"
  exit 1
}

echo "Successfully created a new PUBLIC git repository named '$repo_name' and pushed it to GitHub."
