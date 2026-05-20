# Execution Plan: Erebor Initial Config

## Change Impact Assessment
- **User-facing**: No (system config only)
- **Structural**: Yes — new modules added to core and nixos layers
- **Data model**: No
- **API/interface**: No
- **NFR impact**: Low — standard NixOS module patterns

## Risk Assessment
- **Risk Level**: Low
- **Rollback**: Easy — all changes are additive except users.nix modification
- **Testing**: `nix flake check` / `nix build .#nixosConfigurations.erebor.config.system.build.toplevel`

---

## Workflow Visualization

```
INCEPTION PHASE
  [x] Workspace Detection      COMPLETED
  [-] Reverse Engineering      SKIPPED  (source repo read directly)
  [x] Requirements Analysis    COMPLETED
  [-] User Stories             SKIPPED  (infra config, no personas)
  [x] Workflow Planning        IN PROGRESS
  [-] Application Design       SKIPPED
  [-] Units Generation         SKIPPED

CONSTRUCTION PHASE
  [-] Functional Design        SKIPPED
  [-] NFR Requirements         SKIPPED
  [-] NFR Design               SKIPPED
  [-] Infrastructure Design    SKIPPED
  [>] Code Generation          EXECUTE
  [>] Build and Test           EXECUTE

OPERATIONS PHASE
  [ ] Operations               PLACEHOLDER
```

---

## Phases to Execute

### INCEPTION PHASE
- [x] Workspace Detection — COMPLETED
- [x] Requirements Analysis — COMPLETED
- [x] Workflow Planning — IN PROGRESS
- [-] All other inception stages — SKIPPED

### CONSTRUCTION PHASE — Code Generation

**Design pattern**:
- Core modules go in `modules/core/` and contribute to `flake.modules.nixos.core` (applied to all hosts)
- Named NixOS modules go in `modules/nixos/` and contribute to `flake.modules.nixos.<name>` (opt-in per host)
- Per-host opt-in via NixOS `imports` list: `imports = [ config.flake.modules.nixos.nvidia ]`
  - `config` here is the **flake-parts** config, referenced from the outer `{ config, ... }:` scope of the host's flake-parts module
- Unfree packages declared at flake-parts level via `nixpkgs.allowedUnfreePackages` (nix-iv pattern)
- No enable options — just import or don't

Files to **create**:

1. `modules/flake/unfree.nix`
   - Declares `nixpkgs.allowedUnfreePackages` as a flake-parts list option
   - Sets `flake.modules.nixos.core.nixpkgs.config.allowUnfreePredicate` from that list
   - Pattern from nix-iv

2. `modules/core/networking.nix`
   - `flake.modules.nixos.core` → `networking.networkmanager.enable = true`

3. `modules/core/services.nix`
   - `flake.modules.nixos.core` → pipewire (alsa, pulse), printing, udisks2, openssh (off by default, hardened)

4. `modules/core/security.nix`
   - `flake.modules.nixos.core` → rtkit, polkit, polkit-gnome systemd user service

5. `modules/nixos/nvidia.nix`
   - Flake-parts module that exposes `flake.modules.nixos.nvidia` (plain NixOS config, no options)
   - Also declares `nixpkgs.allowedUnfreePackages` for nvidia packages

Files to **modify**:

6. `modules/hosts/erebor/default.nix`
   - Add `{ config, ... }:` arg to the flake-parts module
   - Add `imports = [ config.flake.modules.nixos.nvidia ]` inside `flake.modules.nixos."nixosConfigurations/erebor"`

7. `modules/hosts/erebor/users.nix`
   - No changes — existing jake user config retained as-is

### CONSTRUCTION PHASE — Build and Test
- Run `nix flake check`
- Run `nix build .#nixosConfigurations.erebor.config.system.build.toplevel`

---

## Success Criteria
- `nix flake check` passes
- erebor toplevel builds
- All common config ported to core modules
- Nvidia included via `imports` in erebor host module
- No user accounts defined
