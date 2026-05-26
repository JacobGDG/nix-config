# Session 5 Requirements - jake-laptop-nixos Host Import

## Scope
Import the jake-laptop-nixos host configuration from /tmp/nix-config-src/ into the dendritic-flake-parts repo, converting to established flake-parts + import-tree patterns.

## Functional Requirements

### FR-1: Host Configuration Files
Create `modules/hosts/jake-laptop-nixos/` with:
- `default.nix` - Host definition, NixOS + HM module imports
- `hardware-configuration.nix` - AMD laptop hardware (from source)
- `users.nix` - jake user definition

### FR-2: Battery NixOS Module
Create `modules/system/battery.nix` with:
- TLP power management (performance on AC, powersave on battery)
- Charge thresholds (40-80%)
- thermald, powertop
- Pattern: `flake.modules.nixos.battery`

### FR-3: Battery Warning Daemon HM Module
Create `modules/system/battery-warning-daemon.nix` with:
- Systemd user service monitoring BAT1
- Desktop notifications via libnotify at <=20%
- Pattern: `flake.modules.homeManager.batteryWarningDaemon`

### FR-4: Host NixOS Module Imports
jake-laptop-nixos NixOS imports (differs from erebor - no nvidia, adds battery):
- hyprland, firefox, steam, battery

### FR-5: Host HM Module Imports
jake-laptop-nixos HM imports (same as erebor + batteryWarningDaemon):
- hyprland, waybar, dunst, hypridle, hyprlock, hyprpaper, wlogout, wofi
- terminal, firefox, aiAgents, devops, spotifyPlayer, cava, mpv
- batteryWarningDaemon

### FR-6: Shared Package Migration
Move linux-base packages that apply to BOTH hosts into jake.nix:
- wl-clipboard, sshfs, bc, unzip, ruby (currently only in erebor host)
- blender, prismlauncher, mumble, discord, rpi-imager, spotify (new)
Update erebor host to remove packages now in jake.nix.

### FR-7: Host-Specific Packages
- erebor: btop-cuda (nvidia-specific), nerd-fonts.jetbrains-mono
- jake-laptop-nixos: btop (no nvidia)

### FR-8: jake@jake-laptop-nixos Module
Add empty `flake.modules.homeManager."jake@jake-laptop-nixos" = {};` to jake.nix.

### FR-9: stateVersion
- NixOS system.stateVersion = "24.05"
- HM home.stateVersion = "24.05"

## Non-Functional Requirements
- Follow established flake-parts + import-tree patterns from prior sessions
- No new flake inputs needed (wireguard/ragenix skipped)
- Extensions: Security Baseline = No, Property-Based Testing = No

## Out of Scope
- Wireguard (requires ragenix)
- Homelab modules
- llm, genealogy, sops, nix-update-app modules
- Private-config, wallpapers, prompts inputs
