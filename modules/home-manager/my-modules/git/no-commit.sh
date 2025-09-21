#!/usr/bin/env bash

#
# To prevent debug code from being accidentally committed, simply add a comment near your
# debug code containing the keyword !nocommit and this script will abort the commit.
#

# get staged files
FILES=$(git diff --cached --name-only)

# iterate over FILES and look for !nocommit
for file in $FILES; do
  if grep -q '!nocommit' "$file"; then
    echo -e "'!nocommit' found in $file"
    exit 1
  fi
done
