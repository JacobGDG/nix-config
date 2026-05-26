# Session 7 Execution Plan - work-mac Home Manager Import

## Workflow Assessment
- **Project Type**: Brownfield (session 7)
- **Depth**: Minimal - patterns fully established, source config is clear
- **Key Change**: hosts.nix refactored by user to use `hosts` option with `configurator` field.
  darwin hosts use default `noop` configurator - no separate darwinHosts option needed.

## Stages to Execute

### INCEPTION
- [x] Workspace Detection - COMPLETE
- [x] Requirements Analysis - COMPLETE (requirements-6.md)
- [ ] Workflow Planning - THIS DOCUMENT

### CONSTRUCTION
- [ ] Code Generation
- [ ] Build and Test

---

## Code Generation Plan

### Step 1: ~~Modify modules/flake/home-manager.nix~~ - DONE BY USER
nixosHosts -> hosts already updated.

### Step 2: Modify modules/core/packages.nix
Wrap `wl-clipboard` and `sshfs` in `lib.optionals stdenv.isLinux`.

### Step 3: Modify modules/shell/tmux.nix
Remove `programs.zsh.shellAliases."pbcopy" = "wl-copy"` entirely.
User will use wl-copy directly.

### Step 4: ~~Create modules/development/llm.nix~~ - SKIPPED
Skipped per user instruction.

### Step 5: Create modules/jakegreenwood.nix
New user module: imports zsh, starship, tmux, sesh, tmuxifier, git, neovim, aiAgents,
terminal, scripts. Packages: ripsecrets, ttyper, jq, yq-go, spotify.
(llm removed per FR-5 skip)

### Step 6: Create modules/hosts/work-mac/default.nix
Host module: hosts.work-mac (aarch64-darwin, noop configurator), mac-app-util input + HM import,
darwin-specific config (nix.conf, sessionPath, packages, devops import).
(no pbcopy override needed - alias removed from tmux.nix entirely)

### Step 7: Create modules/hosts/work-mac/users.nix
User@host: jakegreenwood@work-mac (username, homeDir, stateVersion = "24.05").

### Step 8: Update aidlc-state.md and audit.md

---

## Files Modified
| File | Action |
|------|--------|
| ~~modules/flake/home-manager.nix~~ | DONE - nixosHosts -> hosts |
| modules/core/packages.nix | MODIFY - linux-only guard for wl-clipboard + sshfs |
| modules/shell/tmux.nix | MODIFY - remove pbcopy alias |
| ~~modules/development/llm.nix~~ | SKIPPED |
| modules/jakegreenwood.nix | CREATE |
| modules/hosts/work-mac/default.nix | CREATE |
| modules/hosts/work-mac/users.nix | CREATE |
