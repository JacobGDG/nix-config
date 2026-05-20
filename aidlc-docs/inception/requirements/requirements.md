# Requirements: Erebor Initial NixOS Config (No Users)

## Intent Analysis

- **User Request**: Import the initial system-level config for the erebor host from JacobGDG/nix-config into the flake-parts framework. No user accounts.
- **Request Type**: Migration (porting config from legacy structure into new flake-parts framework)
- **Scope**: Multiple components — new core NixOS modules + new nixos module + erebor host update + flake-level unfree config
- **Complexity**: Simple — source config is known, target framework is understood, direct mapping

---

## Functional Requirements

### FR-1: Common NixOS Core Modules
Port the following from `nixos/common/` in the source repo into `modules/core/` in the target, applied to all hosts via `flake.modules.nixos.core`:

- **Networking**: `networking.networkmanager.enable = true`
- **Audio**: PipeWire (alsa 32-bit, pulse compat), PulseAudio disabled
- **Printing**: CUPS (`services.printing.enable = true`)
- **Removable media**: `services.udisks2.enable = true`
- **SSH**: openssh disabled by default, `PermitRootLogin = "no"`, no password auth
- **Security**: `security.rtkit.enable = true`, `security.polkit.enable = true`, polkit-gnome systemd user service

### FR-2: Unfree Package Management (nix-iv pattern)
Add `modules/flake/unfree.nix` based on the nix-iv approach:
- Declares `nixpkgs.allowedUnfreePackages` as a flake-level list option
- Sets `nixpkgs.config.allowUnfreePredicate` on `flake.modules.nixos.core` using a package name predicate
- Individual modules declare their own unfree packages via `nixpkgs.allowedUnfreePackages = [...]`

### FR-3: Reusable Nvidia Module
Create `modules/nixos/nvidia.nix` as an opt-in NixOS module:
- `options.myModules.nixos.nvidia.enable` — mkEnableOption
- When enabled: `services.xserver.videoDrivers = ["nvidia"]`, `hardware.graphics.enable = true`, nvidia modesetting, open kernel module, nvidiaSettings
- Declares its unfree packages via `nixpkgs.allowedUnfreePackages`

### FR-4: Erebor Host — Enable Nvidia
Update `modules/hosts/erebor/default.nix` to enable the nvidia module:
- `myModules.nixos.nvidia.enable = true`

### FR-5: Remove User Stub
Remove (empty out) `modules/hosts/erebor/users.nix` — no user accounts in this initial config.

---

## Non-Functional Requirements

- **NFR-1**: All new modules must follow the existing flake-parts `flake.modules.nixos.*` convention
- **NFR-2**: `import-tree` auto-imports all `.nix` files — no manual import registration needed
- **NFR-3**: Unfree packages declared at the module level (not globally) using the predicate pattern

---

## Out of Scope

- Home-manager user config
- User accounts
- Hyprland / desktop environment
- Secrets / agenix
- Wireguard / homelab services
