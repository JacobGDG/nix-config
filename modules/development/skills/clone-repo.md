---
name: clone-repo
description:
  Clone a reference repository to ~/.cache/ref-repos/<owner>/<repo>/<ref> for
  use as context. Use when the user provides a repo URL alongside a task and
  appends /clone-repo.
allowed-tools: Bash, Read
---

# Clone Reference Repository

Make the repo available locally with `git-ref-clone`, then continue with the
user's task using it as read-only context.

## Step 1: Build the arguments

`git-ref-clone` only accepts a plain clone URL:

- `https://<host>/<owner>/<repo>[.git]`
- `git@<host>:<owner>/<repo>[.git]`

Normalise what the user gave you:

- **Shorthand** `owner/repo` → `https://github.com/owner/repo`
- **Tree URL** `https://github.com/owner/repo/tree/<ref>` → URL
  `https://github.com/owner/repo` and ref `<ref>`
- Use HTTPS unless the user explicitly gave an SSH URL.

The ref is a branch or tag; omit it to use the remote's default branch. Commit
SHAs are not supported. Add `--deep` only when full history is needed (e.g.
`git log` or blame across history); the default is a shallow clone.

## Step 2: Run it

```
git-ref-clone [--deep] <url> [ref]
```

It first prunes clones older than 30 days, then clones or reuses
`~/.cache/ref-repos/<owner>/<repo>/<ref>` (slashes in the ref become `-`).
Progress goes to stderr; the last line of stdout is the clone path. If the clone
already exists it is reused as-is and the age of its last commit is reported —
mention that age to the user if it is old, since branch clones are not updated.

A non-zero exit means the URL was rejected or the ref does not exist; report the
error rather than retrying with other tools.

## Step 3: Report and continue

Tell the user the local path, the ref, whether it was freshly cloned or already
present, and the last commit age. Then continue with the original task, treating
the path as read-only context. Use `Read`, `Bash(find:*)`, and `Bash(grep:*)` to
explore it.
