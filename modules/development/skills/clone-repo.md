---
name: clone-repo
description: Clone or update a reference repository to ~/.cache/ref-repos/<owner>/<repo> for use as context. Use when the user provides a repo URL alongside a task and appends /clone-repo.
allowed-tools: Bash, Read
---

# Clone Reference Repository

Parse the repo reference from the user's message and ensure it is available locally at `~/.cache/ref-repos/<owner>/<repo>`.

## Step 1: Parse the repo reference

The user will provide one of these formats:

- **Full HTTPS URL**: `https://github.com/owner/repo` or `https://github.com/owner/repo/tree/<ref>`
- **SSH URL**: `git@github.com:owner/repo.git`
- **Shorthand**: `owner/repo` (assume GitHub; construct `https://github.com/owner/repo`)

Extract:
- `OWNER` — the repository owner/org
- `REPO` — the repository name (strip any `.git` suffix)
- `REF` — branch or tag if present in the URL (e.g. from `/tree/<ref>`), otherwise empty (use the remote default branch)
- `CLONE_URL` — normalised clone URL; use HTTPS unless SSH was explicitly given

## Step 2: Determine the target path

```
TARGET=~/.cache/ref-repos/<OWNER>/<REPO>
```

## Step 3: Handle existing clone

Check whether `$TARGET` already exists with `[ -d "$TARGET" ]`.

**Exists:**
- Read the current ref and hash: `(cd "$TARGET" && git log -1 --pretty="format:%D %H")`
- Tell the user what ref is currently checked out.
- Ask: "The existing clone is at `<current-ref>`. Remove it and re-clone?" Wait for confirmation before proceeding.
- If confirmed, the user must approve the `rm -rf` permission prompt; then re-clone (go to Step 4).
- If declined, skip to Step 5 using the existing clone as-is.

**Does not exist:**
- `mkdir -p ~/.cache/ref-repos/<OWNER>` then proceed to Step 4.

## Step 4: Clone

Always use `--depth 1` (shallow).

- **No ref**: `git clone --depth 1 <CLONE_URL> <TARGET>`
- **With a tag or branch**: `git clone --depth 1 --branch <REF> <CLONE_URL> <TARGET>`

## Step 5: Report and continue

Tell the user:
- Local path: `~/.cache/ref-repos/<OWNER>/<REPO>`
- Checked-out ref: from the output already read in Step 3 (or re-run `(cd "$TARGET" && git log -1 --pretty="format:%D %H")` if freshly cloned)
- Action taken: freshly cloned, re-cloned at new ref, or used existing

Then continue with the original task the user asked you to perform, treating the cloned path as additional read-only context. Use `Read`, `Bash(find:*)`, and `Bash(grep:*)` to explore it.
