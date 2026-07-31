---
name: clone-repo
description: Clone or update a reference repository to ~/.cache/ref-repos/<owner>/<repo> for use as context. Use when the user provides a repo URL alongside a task and appends /clone-repo.
allowed-tools: Bash
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

Check whether `$TARGET` already exists with `ls "$TARGET" 2>/dev/null`.

**Exists and a specific REF was requested:**
- Read the current ref: `git -C "$TARGET" describe --tags --exact-match 2>/dev/null || git -C "$TARGET" rev-parse --abbrev-ref HEAD`
- If it **does not match** the requested REF → tell the user what ref is currently checked out and what was requested, then ask: "The existing clone is at `<current-ref>`. Remove it and re-clone at `<requested-ref>`?" Wait for confirmation before proceeding. If confirmed, the user must approve the `rm -rf` permission prompt; then re-clone (go to Step 4).
- If it **matches** → `git -C "$TARGET" fetch --depth 1 origin "$REF"` then `git -C "$TARGET" reset --hard FETCH_HEAD`

**Exists and no specific REF was requested:**
- `git -C "$TARGET" pull` to update to the latest default branch

**Does not exist:**
- `mkdir -p ~/.cache/ref-repos/<OWNER>` then proceed to Step 4

## Step 4: Clone

Always use `--depth 1` (shallow).

- **No ref**: `git clone --depth 1 <CLONE_URL> <TARGET>`
- **With a tag or branch**: `git clone --depth 1 --branch <REF> <CLONE_URL> <TARGET>`

## Step 5: Report and continue

Tell the user:
- Local path: `~/.cache/ref-repos/<OWNER>/<REPO>`
- Checked-out ref (default branch name or the specified ref)
- Action taken: freshly cloned, updated, or re-cloned at new ref

Then continue with the original task the user asked you to perform, treating the cloned path as additional read-only context. Use `Read`, `Bash(find:*)`, and `Bash(grep:*)` to explore it.
