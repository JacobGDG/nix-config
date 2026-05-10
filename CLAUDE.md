# CLAUDE.md

This is the **dendritic rebuild** branch of `nix-config`. The goal is to migrate the existing host-centric NixOS/home-manager config to the [dendritic pattern](https://github.com/vic/den) using `vic/den`, `vic/import-tree`, `vic/flake-file`, and `hercules-ci/flake-parts`.

The old structure lives on the `main` branch, accessible at `../` (this is a git worktree).

---

## Key Constraint

**`flake.nix` is AUTO-GENERATED.** Never edit it directly.
Regenerate after any input changes:
```bash
nix run .#write-flake --show-trace
```

---

## Commands

```bash
nix run .#write-flake --show-trace     # Regenerate flake.nix after input changes
just hm                                # Apply home-manager for current user@host
just os                                # Apply NixOS config for current host
just check                             # nix flake check
nix develop                            # Enter devShell
```

**Formatting:** `alejandra .` (enforced via pre-commit).

---

## Target Directory Layout

```
flake.nix                   # AUTO-GENERATED — do not edit
flake.lock
Justfile
modules/
  meta/
    default.nix             # systems list: [ "x86_64-linux" "aarch64-darwin" ]
    inputs.nix              # imports den + flake-file modules; declares flake inputs via flake-file
    den.nix                 # namespace declaration (jk), stateVersion defaults, schema defaults
    devshells.nix           # perSystem devShells
  hosts/
    <hostname>.nix          # den.hosts declaration + den.aspects.<hostname> NixOS config
  me.nix                    # jake user: den.homes or den.hosts user + composes jk.* aspects
  <feature>/
    default.nix             # composite aspect: jk.<feature>.includes = with jk; [ ... ]
    <concern>.nix           # leaf aspect: jk.<concern>.homeManager/nixos = { ... }
```

`import-tree` auto-imports every `.nix` file under `modules/`. Files/dirs prefixed with `_` are excluded. No manual imports needed.

---

## Core Concepts

### Namespace

The namespace is `jk` (declared in `modules/meta/den.nix`):
```nix
imports = [ (inputs.den.namespace "jk" false) ];
```
This makes `jk` available as a module arg. Feature aspects are registered as `jk.<name>.homeManager = ...` and/or `jk.<name>.nixos = ...`.

### Aspects

An aspect bundles config for multiple Nix classes:
```nix
jk.cava.homeManager = { programs.cava.enable = true; };
jk.hyprland.nixos = { programs.hyprland.enable = true; };
jk.hyprland.homeManager = { wayland.windowManager.hyprland.enable = true; };
```

Composites use `includes`:
```nix
jk.desktop.includes = with jk; [ hyprland waybar dunst kitty ];
```

### Hosts & Users

**NixOS host:**
```nix
den.hosts.x86_64-linux.<hostname>.users.jake = {};
den.aspects.<hostname> = {
  includes = [ den.provides.hostname ];
  nixos = { pkgs, ... }: { ... };
};
```

**Standalone home (no NixOS):**
```nix
den.homes.aarch64-darwin.jakegreenwood = {};
```

### Flake inputs per feature

Any module can declare its own flake input alongside its config:
```nix
# modules/tui/neovim.nix
{ inputs, ... }: {
  flake-file.inputs.neovim.url = "git+ssh://git@github.com/JacobGDG/nvim.nix.git?shallow=1";
  jk.neovim.homeManager = { pkgs, ... }: {
    nixpkgs.overlays = [ inputs.neovim.overlays.default ];
    home.packages = [ pkgs.nvim-pkg ];
  };
}
```

### `den.provides.*` batteries

| Battery | Description |
|---|---|
| `den.provides.define-user` | Creates OS user account |
| `den.provides.primary-user` | Admin/primary user on NixOS |
| `den.provides.user-shell "zsh"` | Sets login shell |
| `den.provides.tty-autologin "jake"` | TTY autologin |
| `den.provides.hostname` | Sets `networking.hostName` |
| `den.provides.unfree` | Permits unfree packages |

---

## Hosts

| Host | System | Type | User |
|---|---|---|---|
| `jake-laptop-nixos` | `x86_64-linux` | NixOS | `jake` |
| `erebor` | `x86_64-linux` | NixOS | `jake` |
| `jakegreenwood@MacOS` / `work-mac` | `aarch64-darwin` | standalone home | `jakegreenwood` |

---

## Private/Secret Inputs

Several inputs are private SSH-authenticated repos — only available in the owner's environment:
- `mysecrets` — secrets encrypted with ragenix/age
- `wallpapers`, `prompts`, `neovim`, `private-config` — personal content

Declare these via `flake-file.inputs` in the relevant feature module.

---

## Reference

- Old config (main branch): `../` or `git show main:<path>`
- Working memory / session context: `./working-memory/` (not committed)
- Test repo (confirmed working): `./working-memory/nix-dendritic-test/`
- `vic/den` source: `./working-memory/den/`
- `vic/import-tree`: `./working-memory/import-tree/`
- `vic/flake-file`: `./working-memory/flake-file/`
