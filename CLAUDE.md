# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

The `nix-config` script and `just` are the primary entry points:

```bash
just hm          # Apply home-manager config for current user@host
just os          # Apply NixOS config for current host
just check       # Run `nix flake check`
just update      # Update select flake inputs (agenix, mysecrets, wallpapers, prompts, neovim, private-config)
just full_update # Update all flake inputs
just clean       # Garbage collect old nix generations
just full_sync   # git pull + os + hm
```

The underlying script (`./nix-config`) auto-detects the current hostname and user, so `just hm` is equivalent to:
```bash
home-manager switch --flake .#"$(whoami)"@"$(hostname)" --show-trace
```

**Formatting:** Nix files use `alejandra` (enforced via pre-commit). Run `alejandra .` to format.

**Linting/pre-commit hooks:** trailing whitespace, end-of-file, YAML checks, secret scanning (`ripsecrets`), and alejandra formatting.

## Architecture

### Flake structure

`flake.nix` defines two types of outputs:

- `nixosConfigurations` — full NixOS system configs (hosts: `jake-laptop-nixos`, `erebor`)
- `homeConfigurations` — standalone home-manager configs (hosts: above + `jakegreenwood@MacOS`)

Both use builder helpers (`mkNixos`, `mkHome`) that wire up shared overlays (unstable pkgs + neovim overlay), pass `inputs` and `mylib` as `specialArgs`/`extraSpecialArgs`, and inject `ragenix` for secrets.

### Directory layout

```
flake.nix               # Entry point; defines all hosts and builder helpers
mylib/default.nix       # Shared lib helpers (scanPaths, homeManagerModules, nixosModules, mkEnableOptionWithDefault)
hosts/                  # Per-host home-manager entry points
  common/
    base.nix            # Packages/programs common to all hosts
    linux-base.nix      # Linux-only additions; enables myModules for desktop
    darwin-base.nix     # macOS additions
nixos/
  common/               # NixOS config shared across all NixOS hosts
  <hostname>/           # Host-specific NixOS config (hardware, users, enabled modules)
modules/
  home-manager/         # Home-manager module implementations
    my-modules/         # Custom option-based modules under `myModules.*` namespace
  nixos/                # NixOS module implementations under `myModules.nixOS.*`
```

### The `myModules` option system

Both home-manager and NixOS use a custom option namespace (`myModules`) to enable/configure features declaratively. Modules under `modules/home-manager/my-modules/` and `modules/nixos/` declare `options.myModules.*` and implement `config` behind those options. Hosts enable features like:

```nix
myModules = {
  hyprland.enable = true;
  firefox.enable = true;
  nixOS.battery.enable = true;
};
```

### `mylib.scanPaths`

`default.nix` files in module directories use `mylib.scanPaths ./.` to auto-import all `.nix` files and subdirectories in the same directory (excluding `default.nix` itself). This means adding a new `.nix` file to a scanned directory is sufficient to include it — no manual import needed.

### Private/secret inputs

Several flake inputs are private SSH-authenticated repos:
- `mysecrets` — secret values (encrypted with ragenix/age)
- `wallpapers`, `prompts`, `neovim`, `private-config` — personal content

These are only available in the owner's environment. Changes to files that reference these inputs may not be buildable in other environments.

### Nixpkgs channels

- `nixpkgs` tracks `nixos-25.11` (stable)
- `nixpkgs-unstable` tracks `master`, exposed as `pkgs.unstable` via overlay
