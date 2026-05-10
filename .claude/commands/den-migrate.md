Migrate a feature from the legacy nix-config to the dendritic pattern.

## Argument

The topic/application/feature to migrate: $ARGUMENTS

## Steps

### 1. Clarify

If the topic is ambiguous, ask the user to clarify before proceeding.

### 2. Search the legacy structure

Search the `main` branch using `git show main:<path>` to find all files that touch this topic. Search across these directories:

- `modules/nixos/`
- `modules/home-manager/`
- `modules/home-manager/my-modules/`
- `hosts/`
- `hosts/common/`
- `nixos/`

Use `git show main:<file>` to read file contents. To list files in a directory on main, run:
```
git ls-tree -r --name-only main -- <path>
```

Search broadly — a topic may touch multiple directories (e.g. steam has both a NixOS module and may appear in host files).

### 3. Understand the full picture

Before writing any code, summarise:
- What NixOS config is involved (system packages, services, options)
- What home-manager config is involved (user packages, programs, files)
- Whether it is host-specific or shared across hosts
- Any secrets, overlays, or private inputs involved

### 4. Propose a location

Look at the existing `modules/` directory structure in the current branch. Suggest where the new aspect file should live. Do not create it yet — confirm with the user first.

### 5. Convert to dendritic pattern

Once location is confirmed, create the aspect file following these rules:

- NixOS config and home-manager config for the same feature go in **the same file**
- Register the aspect under the `jg` namespace: `jg.<name>.nixos = ...` and/or `jg.<name>.homeManager = ...`
- If the feature has its own flake input, declare it inline via `flake-file.inputs.<name>.url = ...`
- Do not add `mkIf` guards unless the old code had meaningful conditions — prefer aspect inclusion/exclusion at the host/user level
- Leave a comment placeholder for host-specific config if relevant, and ask the user whether it is still needed

### 6. Wire up

Tell the user which aspect to add to `me.nix` or the relevant host file to activate the feature. Do not edit those files unless asked.
