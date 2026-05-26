# Session 7 Requirements - work-mac Home Manager Import

## Scope
Import the work-mac home-manager configuration from /tmp/nix-config-src/ into the
dendritic-flake-parts repo for a new user `jakegreenwood` on a macOS (aarch64-darwin) host.
No NixOS/nix-darwin system configuration - standalone home-manager only.

## Source Analysis

Source files:
- `hosts/work-mac.nix` - top-level HM config for jakegreenwood
- `hosts/common/darwin-base.nix` - macOS-specific base (mac-app-util, session paths, nix.conf)
- `hosts/common/base.nix` - shared base (common tools: zsh, tmux, nvim, git, etc.)

## Architecture

The `hosts` option (added by user in hosts.nix) supports a `configurator` field (default: "noop").
Only hosts with `configurator = "nixos"` generate nixosConfigurations.
`work-mac` uses the default `noop` configurator - it registers its system for HM config
generation without triggering any OS-level configuration.

`home-manager.nix` currently references `config.nixosHosts` which no longer exists - it
must be updated to `config.hosts`.

## Functional Requirements

### FR-1: home-manager.nix - nixosHosts -> hosts
Update `modules/flake/home-manager.nix`:
- Change `config.nixosHosts.${host}.system` to `config.hosts.${host}.system`
 > this is done

### FR-2: mac-app-util Flake Input
Add `mac-app-util` input (github:hraban/mac-app-util) via `flake-file.inputs.mac-app-util.url`
in `modules/hosts/work-mac/default.nix`.

### FR-3: work-mac Host Module
Create `modules/hosts/work-mac/default.nix`:
- `hosts.work-mac.system = "aarch64-darwin"` (configurator defaults to "noop")
- `flake.modules.homeManager.work-mac`:
  - imports mac-app-util.homeManagerModules.default
  - xdg.configFile."nix/nix.conf" (experimental-features = nix-command flakes)
  - home.sessionPath: /nix/var/nix/profiles/default/bin, /opt/homebrew/bin
  - packages: jira-cli-go, btop, docker-credential-helpers, dbeaver-bin, python311+pip
  - devops module import
  - programs.zsh.shellAliases."pbcopy" override (prevent wl-copy alias from tmux module)

Create `modules/hosts/work-mac/users.nix`:
- `flake.modules.homeManager."jakegreenwood@work-mac"`:
  - home.username = "jakegreenwood"
  - home.homeDirectory = "/Users/jakegreenwood"
  - home.stateVersion = "24.05"

### FR-4: jakegreenwood User Module
Create `modules/jakegreenwood.nix`:
- `nixpkgs.allowedUnfreePackages`: dbeaver-bin, spotify
- `flake.modules.homeManager.jakegreenwood`:
  - imports: zsh, starship, tmux, sesh, tmuxifier, git, neovim, aiAgents, llm, terminal, scripts
  - packages: ripsecrets, ttyper, jq, yq-go, spotify

### FR-5: LLM Module
Create `modules/development/llm.nix`:
- `flake.modules.homeManager.llm`:
  - home.packages = [pkgs.llm]
> Skip this entirely

### FR-6: Linux-Only Package Guards in core/packages.nix
Modify `modules/core/packages.nix`:
- `wl-clipboard` and `sshfs` wrapped with `lib.optionals stdenv.isLinux`

### FR-7: Linux-Only Alias Guard in shell/tmux.nix
Modify `modules/shell/tmux.nix`:
- `programs.zsh.shellAliases."pbcopy" = "wl-copy"` wrapped in `lib.mkIf pkgs.stdenv.isLinux`
 > remove this alias entirely. I will use wl-copy directly

## Non-Functional Requirements
- Follow established flake-parts + import-tree patterns from prior sessions
- Extensions: Security Baseline = No, Property-Based Testing = No (carried from session 3)
- No nix-darwin system config (user explicitly requested no OS config)

## Out of Scope
- nix-darwin system configuration
- tomato-c (commented out in source due to mpv build failure on mac)
