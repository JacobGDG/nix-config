# Migration Checklist

Features to migrate from `main` branch to the dendritic pattern.
Use `/den-migrate <topic>` to help work through each item.

## TUI

- [x] zsh + starship (`modules/tui/zsh.nix`, `modules/tui/starship.nix`)
- [x] neovim (`modules/tui/neovim.nix`) — private input
- [x] tmux + sesh + tmuxifier (`modules/tui/tmux.nix`)
- [x] zoxide (`modules/tui/zoxide.nix`)
- [x] direnv + nix-direnv (`modules/tui/direnv.nix`)
- [x] ripgrep (`modules/tui/ripgrep.nix`)
- [x] git + jujutsu + pre-commit hooks (`modules/tui/git.nix`, `modules/tui/jujutsu.nix`)
- [x] misc packages + fonts (`modules/me.nix`)
- [x] linux-specific packages (`modules/hosts/linux.nix`)

## Desktop (Linux only)

- [x] hyprland — NixOS + HM (`modules/desktop/hyprland/default.nix`)
- [x] waybar (`modules/desktop/hyprland/waybar.nix`)
- [x] dunst (`modules/desktop/hyprland/dunst.nix`)
- [x] wofi (`modules/desktop/hyprland/wofi.nix`)
- [x] hyprlock (`modules/desktop/hyprland/hyprlock.nix`) — wallpaper TODO
- [x] hypridle (`modules/desktop/hyprland/hypridle.nix`)
- [x] hyprpaper (`modules/desktop/hyprland/hyprpaper.nix`) — wallpaper TODO
- [x] wlogout (`modules/desktop/hyprland/wlogout.nix`)
- [x] firefox — NixOS + HM (`modules/applications/firefox.nix`)
- [x] mpv (`modules/applications/mpv.nix`)
- [x] kitty (`modules/applications/kitty.nix`)
- [x] cava (`modules/applications/cava.nix`) — TODO: configure settings/theming
- [x] dconf (`modules/applications/dconf.nix`) — TODO: configure GTK dark theme
- [x] spotify-player (`modules/applications/spotify-player.nix`)
- [x] thunderbird (`modules/applications/thunderbird.nix`) — TODO: configure profiles
- [x] udiskie + dolphin (`modules/applications/filemanager.nix`)
- [x] libreoffice (`modules/applications/libreoffice.nix`)
- [x] genealogy (`modules/applications/genealogy.nix`)

## System (NixOS)

- [x] locale (`nixos/common/locale.nix`) — inlined into `den.default.nixos` in `modules/meta/defaults.nix`
- [x] nix settings (`nixos/common/nix.nix`) — all defaults (locale, nix settings, stateVersion) consolidated in `modules/meta/defaults.nix`; `den.nix` kept minimal (namespace + schema only)
- [x] polkit + rtkit + printing + udisks + pipewire + openssh + networking (`modules/system/bootable.nix`)
- [ ] battery — NixOS + HM warning daemon (`modules/nixos/battery.nix`, `modules/home-manager/my-modules/battery-warning-daemon.nix`) — laptop only, skip for now
- [x] nvidia (`modules/system/nvidia.nix`) — erebor specific
- [x] steam (`modules/system/steam.nix`)
- [ ] wireguard (`modules/nixos/wireguard.nix`)

## AI / LLM

- [ ] llm (`modules/home-manager/my-modules/llm.nix`)
- [x] ai-agents / claude-code (`modules/tui/claude.nix`) — registered under `jg.ai`

## Scripts

- [x] scripts pattern established (`modules/packages/`) — overlay via `den.default.homeManager`
- [x] hyprland scripts: `hyprctl-conditional-quit`, `media-control`, `quick-access-kitty`, `show-keymaps`, `wofi-bookmarks`
- [ ] wireguard scripts: `wg-manager`, `wg-waybar`, `wg-wofi` — migrate with wireguard module
- [ ] devops scripts: `aws-console`, `clean-pr`, `create-app`, `git-repo`, `jira-id`, `k-cm-dependants`, `open-last-url`, `password_entropy`, `random` — migrate with devops module
- [ ] `prepare-commit`, `prepare-pr` (Ruby) — need `inputs.prompts` private input first

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
