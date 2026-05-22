# Requirements Clarification: Erebor Full Config Migration (with Jake)

Please answer the following questions to clarify the scope and approach for this migration.

---

## Question 1
What is the scope of the migration for jake's home-manager configuration?

The source repo has many modules. The **core** set covers the desktop, terminal, and dev tools.
The **full** set adds app-specific modules also imported by erebor in the source.

**Core** includes:
- Full desktop suite (hyprland, waybar, dunst, hypridle, hyprlock, hyprpaper, wlogout, wofi)
- Terminal (kitty, zsh + starship, tmux + sesh + tmuxifier)
- Dev tools (git + jujutsu + global pre-commit, neovim)
- Common packages (direnv, fzf, gh, ripgrep, zoxide, just, obsidian, nerd-fonts, etc.)
- Jake NixOS user account + home identity

**Full** additionally includes:
- Firefox
- MPV
- LibreOffice, Thunderbird, udiskie, dconf
- Spotify-player (terminal), cava (audio visualiser)
- PrismLauncher, Discord, Mumble, Blender
- Genealogy app
- AI agents + LLM tools
- nix-update-app, scripts module

A) Core only — focus on the essentials; apps can be added incrementally
B) Full — migrate everything erebor currently uses from the source
C) Other (please describe after [Answer]: tag below)

[Answer]: A

---

## Question 2
How should the neovim module be handled?

The source uses a private overlay package `nvim-pkg` from `git+ssh://git@github.com/JacobGDG/nvim.nix.git`.
The target currently has no neovim input.

A) Add the private neovim overlay input (requires SSH key access when running `nix flake update`)
B) Use `pkgs.neovim` from nixpkgs (standard neovim, no custom config from the private repo)
C) Skip neovim for now
D) Other (please describe after [Answer]: tag below)

[Answer]: B

---

## Question 3
Should security extension rules be enforced for this project?

A) Yes — enforce all SECURITY rules as blocking constraints
B) No — skip SECURITY rules (appropriate for a personal Nix config repo)
C) Other (please describe after [Answer]: tag below)

[Answer]: B

---

## Question 4
Should property-based testing (PBT) extension rules be enforced?

A) Yes — enforce PBT rules
B) No — skip PBT rules (not applicable to a Nix configuration repo)
C) Other (please describe after [Answer]: tag below)

[Answer]: B
