# Code Generation Plan — Erebor Full Config (with Jake)

## Unit Context
- **Unit**: Single unit — all modules form one coherent migration
- **Workspace Root**: `/home/jake/src/nix-config/dendritic-flake-parts`
- **Source Reference**: `/tmp/nix-config-src`
- **Requirements**: `aidlc-docs/inception/requirements/requirements-2.md`

---

## Steps

### Step 1: FR-1 — Create `modules/core/colors.nix`
- [x] Create new file
- [x] Define `flake.modules.homeManager.core` contribution: `options.colorScheme.palette` as `attrsOf str`
- [x] Inline gruvbox-dark-medium Base16 values (base00–base0F) as defaults

### Step 2: FR-18 — Update `modules/core/home-manager.nix`
- [x] Read existing file
- [x] Add `news.display = "silent"` to `flake.modules.homeManager.core`

### Step 3: FR-2 — Expand `modules/desktop/hyprland.nix`
- [x] Read existing file
- [x] Expand `flake.modules.homeManager.hyprland` with full config from source:
  - packages (brightnessctl, libnotify, networkmanager_dmenu, pavucontrol, pulseaudio, kdePackages.dolphin, playerctl, grim, slurp, cliphist, ungoogled-chromium)
  - cursor (bibata)
  - fonts.fontconfig.enable
  - full wayland.windowManager.hyprland settings (keybinds, window rules, monitor, colorScheme borders, ecosystem)

### Step 4: FR-10 — Expand `modules/desktop/terminal.nix`
- [x] Read existing file
- [x] Replace stub with full kitty config from source (font, cursor, color palette from colorScheme.palette)

### Step 5: FR-3 — Create `modules/desktop/waybar.nix`
- [x] Create new file
- [x] `flake.modules.homeManager.waybar`: full waybar config (core modules only, no conditionals), systemd UWSM service override

### Step 6: FR-4 — Create `modules/desktop/dunst.nix`
- [x] Create new file
- [x] `flake.modules.homeManager.dunst`: dunst package + dunstrc config file with colorScheme palette

### Step 7: FR-5 — Create `modules/desktop/hypridle.nix`
- [x] Create new file
- [x] `flake.modules.homeManager.hypridle`: services.hypridle with hardcoded timeouts (300s lock, 420s screen-off, 600s suspend)

### Step 8: FR-6 — Create `modules/desktop/hyprlock.nix`
- [x] Create new file
- [x] `flake.modules.homeManager.hyprlock`: programs.hyprlock settings (no background/wallpaper)

### Step 9: FR-7 — Create `modules/desktop/hyprpaper.nix`
- [x] Create new file
- [x] `flake.modules.homeManager.hyprpaper`: hyprpaper package, commented-out hyprpaper.conf placeholder, systemd UWSM service override

### Step 10: FR-8 — Create `modules/desktop/wlogout.nix`
- [x] Create new file
- [x] `flake.modules.homeManager.wlogout`: programs.wlogout with full layout (shutdown/lock/reboot/suspend/logout)

### Step 11: FR-9 — Create `modules/desktop/wofi.nix`
- [x] Create new file
- [x] `flake.modules.homeManager.wofi`: programs.wofi with full settings + style (colorScheme palette), xdg-terminal-exec package

### Step 12: FR-11 — Create `modules/shell/zsh.nix`
- [x] Create new file
- [x] `flake.modules.homeManager.zsh`: full zsh config (autosuggestion, vi-mode, syntax-highlighting, history, aliases, initContent, fzf-tab plugin)

### Step 13: FR-12 — Create `modules/shell/starship.nix`
- [x] Create new file
- [x] `flake.modules.homeManager.starship`: full starship config with colorScheme palette + tg-kube alias

### Step 14: FR-13 — Create `modules/shell/tmux.nix`
- [x] Create new file
- [x] `flake.modules.homeManager.tmux`: full tmux config + inline tmux-other-pane script + pbcopy alias

### Step 15: FR-14 — Create `modules/shell/sesh.nix`
- [x] Create new file
- [x] `flake.modules.homeManager.sesh`: sesh package + inline tmux-sesh-open script + hardcoded sesh.toml defaults

### Step 16: FR-15 — Create `modules/shell/tmuxifier.nix`
- [x] Create new file
- [x] `flake.modules.homeManager.tmuxifier`: tmuxifier package + TMUXIFIER_LAYOUT_PATH + vimsplit + music layout files

### Step 17: FR-16 — Create `modules/development/git.nix`
- [x] Create new file
- [x] `flake.modules.homeManager.git`: programs.git (full config), programs.jujutsu, global pre-commit hook (inline scripts)

### Step 18: FR-17 — Create `modules/development/neovim.nix`
- [x] Create new file
- [x] `flake.modules.homeManager.neovim`: pkgs.neovim package + EDITOR=nvim

### Step 19: FR-19 — Update `modules/jake.nix`
- [x] Read existing file
- [x] Keep hyprland.settings (cross-host defaults: kb_layout, kb_options, exec-once)
- [x] Remove `"jake@erebor" = {}` stub
- [x] Add core packages + programs.direnv/ripgrep/zoxide

### Step 20: FR-21 — Update `modules/hosts/erebor/default.nix`
- [x] Read existing file
- [x] Add `flake.modules.homeManager."jake@erebor"` importing all new HM modules
- [x] Add erebor-specific packages (btop-cuda, wl-clipboard, sshfs, bc, unzip, ruby, tomato-c)
