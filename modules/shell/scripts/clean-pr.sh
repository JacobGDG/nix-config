#!/usr/bin/env bash
set -euo pipefail

# Get PR info
PR_JSON=$(gh pr view --json number,baseRefName,title,body)
BASE_BRANCH=$(echo "$PR_JSON" | jq -r '.baseRefName')
PR_TITLE=$(echo "$PR_JSON" | jq -r '.title')
PR_BODY=$(echo "$PR_JSON" | jq -r '.body')

# Ensure exactly one commit in the PR
COMMIT_COUNT=$(git rev-list --count "${BASE_BRANCH}..HEAD")

if [ "$COMMIT_COUNT" -ne 1 ]; then
  echo "Error: PR must contain exactly one commit (found $COMMIT_COUNT)"
  exit 1
fi

# Get commit title and body
COMMIT_TITLE=$(git log -1 --pretty=%s)
COMMIT_BODY=$(git log -1 --pretty=%b)

# Normalize empty body
COMMIT_BODY=${COMMIT_BODY:-""}
PR_BODY=${PR_BODY:-""}

# Check if update is needed
if [ "$PR_TITLE" = "$COMMIT_TITLE" ] && [ "$PR_BODY" = "$COMMIT_BODY" ]; then
  echo "PR already matches commit. No update needed."
  exit 0
fi

# Update PR
gh pr edit \
  --title "$COMMIT_TITLE" \
  --body "$COMMIT_BODY"

echo "PR updated to match commit."
