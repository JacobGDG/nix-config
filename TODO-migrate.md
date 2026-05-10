# Migration Checklist

Features to migrate from `main` branch to the dendritic pattern.
Use `/den-migrate <topic>` to help work through each item.

## TUI

- [x] zsh + starship (`modules/tui/zsh.nix`, `modules/tui/starship.nix`)
- [ ] neovim (`modules/home-manager/my-modules/neovim.nix`) — private input
- [ ] tmux + sesh + tmuxifier (`modules/home-manager/my-modules/tmux/`)
- [x] git + jujutsu + pre-commit hooks (`modules/tui/git.nix`, `modules/tui/jujutsu.nix`)
- [ ] kitty (`modules/home-manager/my-modules/kitty.nix`)

## Desktop (Linux only)

- [ ] hyprland — NixOS + HM (`modules/nixos/hyprland.nix`, `modules/home-manager/my-modules/hyprland/`)
- [ ] waybar (`modules/home-manager/my-modules/hyprland/waybar.nix`)
- [ ] dunst (`modules/home-manager/my-modules/hyprland/dunst.nix`)
- [ ] wofi (`modules/home-manager/my-modules/hyprland/wofi/`)
- [ ] hyprlock + hypridle (`modules/home-manager/my-modules/hyprland/hyprlock.nix`, `hypridle.nix`)
- [ ] hyprpaper (`modules/home-manager/my-modules/hyprland/hyprpaper.nix`)
- [ ] wlogout (`modules/home-manager/my-modules/hyprland/wlogout.nix`)
- [ ] firefox — NixOS + HM (`modules/nixos/firefox.nix`, `modules/home-manager/my-modules/firefox.nix`)
- [ ] mpv (`modules/home-manager/my-modules/mpv.nix`)

## System (NixOS)

- [x] locale (`nixos/common/locale.nix`) — inlined into `den.default.nixos` in `modules/meta/defaults.nix`
- [x] nix settings (`nixos/common/nix.nix`) — all defaults (locale, nix settings, stateVersion) consolidated in `modules/meta/defaults.nix`; `den.nix` kept minimal (namespace + schema only)
- [ ] polkit + rtkit (`nixos/common/security.nix`)
- [ ] printing + udisks (`nixos/common/services.nix`)
- [ ] pipewire (`nixos/common/services.nix`)
- [ ] openssh (`nixos/common/services.nix`)
- [ ] networking (`nixos/common/networking.nix`)
- [ ] battery — NixOS + HM warning daemon (`modules/nixos/battery.nix`, `modules/home-manager/my-modules/battery-warning-daemon.nix`)
- [ ] nvidia (`modules/nixos/nvidia.nix`) — erebor specific
- [ ] steam (`modules/nixos/steam.nix`)
- [ ] wireguard (`modules/nixos/wireguard.nix`)

## AI / LLM

- [ ] llm (`modules/home-manager/my-modules/llm.nix`)
- [ ] ai-agents (`modules/home-manager/my-modules/ai-agents.nix`) — secrets

## DevOps

- [ ] devops (`modules/home-manager/my-modules/devops.nix`)

## Homelab (erebor only)

- [ ] homer (`modules/nixos/homelab/homer.nix`)
- [ ] traefik (`modules/nixos/homelab/traefik.nix`)

## Hosts

- [x] erebor hardware config (`nixos/erebor/hardware-configuration.nix`) → `modules/hosts/erebor/hardware.nix`
- [ ] jake-laptop-nixos host + hardware config

## Open questions

- Secrets / ragenix — how does it integrate with den?
- `work-mac` / Darwin — nix-darwin or standalone home-manager only?
- `pkgs.unstable` overlay — how under flake-parts?
- `nix-colors` — needed for starship + hyprland theming
- `wallpapers` private input — where does it get declared?
- `private-config` input — what does it provide?
