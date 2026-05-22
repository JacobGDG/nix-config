# Requirements: Erebor Full Config Migration (with Jake)

## Intent Analysis

- **User Request**: Migrate the full erebor config (including jake's user home) from the source repo into the flake-parts framework. All config should live in purpose-built, single-responsibility feature modules. NixOS and homeManager config for the same feature should be grouped in the same file. File/directory naming must be feature-focused (not "nixos/" or "home-manager/").
- **Request Type**: Migration + refactor (port source config, improve module structure)
- **Scope**: Core desktop + terminal + dev tools + jake user identity. Apps (genealogy, cava, discord, etc.) deferred.
- **Complexity**: Medium — multiple modules, no new flake inputs required.

---

## Functional Requirements

### FR-1: Color Scheme Module (no external input)
Create `modules/core/colors.nix`:
- Adds to `flake.modules.homeManager.core` a `options.colorScheme.palette` option (`attrsOf str`)
- Default values are the gruvbox-dark-medium Base16 palette (base00–base0F) inlined directly
- No `nix-colors` input — the palette is self-contained in the module
- `wallpapers` input is NOT added; wallpaper config in hyprpaper/hyprlock uses commented-out placeholder paths

### FR-2: Desktop — Hyprland (system + user)
Expand `modules/desktop/hyprland.nix` homeManager section with full config from source:
- NixOS section: no change to existing (sddm, PAM hyprlock, uwsm, programs.hyprland)
- HM: full `wayland.windowManager.hyprland` settings — keybinds, window rules, monitor layout, cursor, packages (`brightnessctl`, `libnotify`, `networkmanager_dmenu`, `pavucontrol`, `pulseaudio`, `kdePackages.dolphin`, `playerctl`, `grim`, `slurp`, `cliphist`, `ungoogled-chromium`), `colorScheme.palette` for borders, ecosystem settings

### FR-3: Desktop — Waybar
Create `modules/desktop/waybar.nix` (`flake.modules.homeManager.waybar`):
- Core waybar config: style (colorScheme palette), workspaces, clock, cpu, memory, network, pulseaudio, idle_inhibitor, power modules, systemd UWSM service override
- No optional or conditional parts — no GPU widget, no battery, no wireguard, no `options.desktop`

### FR-4: Desktop — Dunst
Create `modules/desktop/dunst.nix` (`flake.modules.homeManager.dunst`):
- dunst package + `dunstrc` config file (colorScheme palette for urgency colours)

### FR-5: Desktop — Hypridle
Create `modules/desktop/hypridle.nix` (`flake.modules.homeManager.hypridle`):
- `services.hypridle` with lock-on-sleep, screen-off, and suspend listeners
- Timeouts hardcoded directly: screenoff = 420s, suspend = 600s (no options)

### FR-6: Desktop — Hyprlock
Create `modules/desktop/hyprlock.nix` (`flake.modules.homeManager.hyprlock`):
- `programs.hyprlock` settings: disable loading bar, grace = 0, hide cursor, input-field styling
- Background section omitted (no wallpaper reference)

### FR-7: Desktop — Hyprpaper
Create `modules/desktop/hyprpaper.nix` (`flake.modules.homeManager.hyprpaper`):
- hyprpaper package + `hypr/hyprpaper.conf` config file
- systemd UWSM service override
- Wallpaper path is a commented-out placeholder (no flake input, no option)

### FR-8: Desktop — Wlogout
Create `modules/desktop/wlogout.nix` (`flake.modules.homeManager.wlogout`):
- `programs.wlogout` with shutdown / lock / reboot / suspend / logout layout

### FR-9: Desktop — Wofi
Create `modules/desktop/wofi.nix` (`flake.modules.homeManager.wofi`):
- `programs.wofi` with full settings and style (colorScheme palette)
- xdg-terminal-exec package

### FR-10: Desktop — Kitty (expand existing terminal.nix)
Expand `modules/desktop/terminal.nix` with full kitty config from source:
- font (JetBrainsMono NF, size 8), cursor (block, no blink), copy-on-select, editor = nvim
- Full colour palette from `colorScheme.palette`

### FR-11: Shell — Zsh
Create `modules/shell/zsh.nix` (`flake.modules.homeManager.zsh`):
- Full zsh config: autosuggestion, vi-mode, syntax-highlighting, history settings
- Shell aliases: `la`, `vim`, `zadd`, `gwt`
- initContent: history key bindings, TMUX auto-attach when in kitty terminal
- fzf-tab plugin (pinned rev from source)

### FR-12: Shell — Starship
Create `modules/shell/starship.nix` (`flake.modules.homeManager.starship`):
- `programs.starship` full config (username, directory, git_branch, git_status, git_state, time, nix_shell, kubernetes, languages) using colorScheme palette
- `programs.zsh.shellAliases."tg-kube"` toggle

### FR-13: Shell — Tmux
Create `modules/shell/tmux.nix` (`flake.modules.homeManager.tmux`):
- Full tmux config: vi-mode, mouse, clock24, gruvbox plugin, smart pane switching with neovim, colorScheme status bar
- Inline `tmux-other-pane` helper script (bash, from source)
- `programs.zsh.shellAliases."pbcopy" = "wl-copy"` (linux clipboard alias)

### FR-14: Shell — Sesh (tmux session manager)
Create `modules/shell/sesh.nix` (`flake.modules.homeManager.sesh`):
- sesh package + inline `tmux-sesh-open` script (from source)
- `xdg.configFile."sesh/sesh.toml"` with hardcoded defaults from the source's base config
- No options — defaults only

### FR-15: Shell — Tmuxifier
Create `modules/shell/tmuxifier.nix` (`flake.modules.homeManager.tmuxifier`):
- tmuxifier package + `TMUXIFIER_LAYOUT_PATH` session variable
- vimsplit and music layout files as `xdg.configFile` (from source)

### FR-16: Development — Git
Create `modules/development/git.nix` (`flake.modules.homeManager.git`):
- `programs.git` full config: user identity (JacobGDG), all aliases from source, init/push/pull defaults, editor = nvim
- `programs.jujutsu` with same user identity
- Global pre-commit hook: inline `no-commit` bash script + `pre-commit-config.yaml`
- `programs.git.settings.core.hooksPath = "${config.xdg.configHome}/git/hooks"`

### FR-17: Development — Neovim
Create `modules/development/neovim.nix` (`flake.modules.homeManager.neovim`):
- `home.packages = [pkgs.neovim]`
- `home.sessionVariables.EDITOR = "nvim"`

### FR-18: Core — HM Core Updates
Update `modules/core/home-manager.nix`:
- Add `news.display = "silent"` to `flake.modules.homeManager.core`
- No nix-colors input — color scheme is provided by FR-1's `modules/core/colors.nix`

### FR-19: Jake User Identity
Update `modules/jake.nix`:
- Keep `wayland.windowManager.hyprland.settings` (kb_layout, kb_options, exec-once) as sensible cross-host defaults
- Remove `"jake@erebor" = {}` entry — it moves to `modules/hosts/erebor/default.nix` with real content
- Keep `flake.modules.homeManager.jake`: `home.username`, `home.homeDirectory`
- Add core packages: fzf, gh, just, nerd-fonts.jetbrains-mono, obsidian, pre-commit, tealdeer, bottom, htop, tree, watch, xclip, jq, yq, ripsecrets, ttyper
- Add programs: `programs.direnv` (nix-direnv, stdlib), `programs.ripgrep` (--smart-case), `programs.zoxide` (zsh integration)

### FR-20: Jake NixOS User Account (erebor)
`modules/hosts/erebor/users.nix` — no change needed:
- `users.users.jake` with `shell = pkgs.zsh` already correct
- `programs.zsh.enable` already provided by `shells.nix` via nixos.core

### FR-21: Erebor Host — Wire Everything
Update `modules/hosts/erebor/default.nix`:
- Add `flake.modules.homeManager."jake@erebor"` importing all new HM modules: hyprland, waybar, dunst, hypridle, hyprlock, hyprpaper, wlogout, wofi, terminal, zsh, starship, tmux, sesh, tmuxifier, git, neovim
- Add erebor-specific packages: `btop-cuda`, `wl-clipboard`, `sshfs`, `bc`, `unzip`, `ruby`, `tomato-c`
- No option overrides needed (wallpaper/hypridle/desktop all simplified to hardcoded values)

---

## Non-Functional Requirements

- **NFR-1**: All modules follow `flake.modules.nixos.*` / `flake.modules.homeManager.*` convention
- **NFR-2**: No module file path or directory name references "nixos" or "home-manager"
- **NFR-3**: Each module file is single-responsibility — one feature per file
- **NFR-4**: NixOS and homeManager config for the same feature live in the same `.nix` file
- **NFR-5**: `import-tree` auto-imports all `.nix` files — no manual registration needed
- **NFR-6**: Color palette uses `config.colorScheme.palette` from the standalone gruvbox module (FR-1) throughout — no nix-colors dependency

---

## Out of Scope

- nix-colors and wallpapers flake inputs (deferred — use inline palette and placeholder)
- Firefox, MPV, LibreOffice, Thunderbird, udiskie, dconf, cava
- PrismLauncher, Discord, Mumble, Blender, rpi-imager
- AI agents, LLM tools, genealogy app
- nix-update-app, custom scripts module
- Sops / secrets / agenix
- Wireguard / homelab services
- Private neovim overlay
