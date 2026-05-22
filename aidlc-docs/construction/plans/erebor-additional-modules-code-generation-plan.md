# Code Generation Plan — Session 3: Additional Erebor Modules

## Unit Context
- **Unit**: erebor-additional-modules
- **Workspace Root**: /home/jake/src/nix-config/dendritic-flake-parts
- **Source**: /tmp/nix-config-src
- **Pattern**: All HM modules use `flake.modules.homeManager.<name>`, NixOS modules use `flake.modules.nixos.<name>`
- **Flat modules**: No `myModules.*` options wrappers

## Dependencies
None — all 7 files are independent. `erebor/default.nix` is modified last to wire imports.

---

## Steps

- [x] Step 1: Create `modules/development/ai-agents.nix`
  - `flake.modules.homeManager.aiAgents`
  - Install `opencode` package
  - Configure `programs.claude-code` with `theme = "dark"`

- [x] Step 2: Create `modules/desktop/firefox.nix`
  - `flake.modules.nixos.firefox` — port policies from source `modules/nixos/firefox.nix`
    - Disable telemetry, pocket, studies, autofill, search suggestions
    - Content blocking strict; AI controls blocked
    - Force-install: uBlock0, LastPass, SponsorBlock, Raindrop.io
  - `flake.modules.homeManager.firefox` — port from source `modules/home-manager/my-modules/firefox.nix`
    - `xdg.mimeApps` defaults for http/https/text/html/about/unknown
    - `programs.firefox` default profile: ddg search, vertical tabs, no saved logins, cache disabled, workspace management disabled

- [x] Step 3: Create `modules/development/devops.nix`
  - `flake.modules.homeManager.devops`
  - Flat module, all tools always included:
    - kubernetes: `kubectl`, `k9s`, `kubectx`, `kustomize`, `cmctl`, `kubernetes-helm`
    - terraform: `tenv`, `tflint`
    - aws: `aws-sso-util`
    - certificates: `step-cli`
  - Shell aliases: `k=kubectl`, `kns=kubens`, `kctx=kubectx`

- [x] Step 4: Create `modules/desktop/spotify-player.nix`
  - `flake.modules.homeManager.spotifyPlayer`
  - `programs.spotify-player.enable = true`

- [x] Step 5: Create `modules/desktop/cava.nix`
  - `flake.modules.homeManager.cava`
  - `programs.cava` with mode=normal, sensitivity=70, foreground=#d79921

- [x] Step 6: Create `modules/desktop/mpv.nix`
  - `flake.modules.homeManager.mpv`
  - Flat module (no options wrapper)
  - `programs.mpv` with uosc + sponsorblock + mpris scripts, wayland support, high-quality profile

- [x] Step 7: Modify `modules/hosts/erebor/default.nix`
  - Add `firefox` to nixos imports list
  - Add to HM imports: `firefox`, `aiAgents`, `devops`, `spotifyPlayer`, `cava`, `mpv`
