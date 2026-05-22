# Requirements — Session 3: Additional Erebor Modules

## Intent Analysis

- **User Request**: Import 6 additional HM/NixOS modules for the erebor host from the source repo at `/tmp/nix-config-src`, following the new repo's flake-parts patterns.
- **Request Type**: Enhancement / Module Port (brownfield)
- **Scope Estimate**: Multiple files — 7 new `.nix` module files + 1 modified host file
- **Complexity Estimate**: Simple — patterns are fully established; task is adaptation not invention

---

## Functional Requirements

### FR-1: ai-agents module
- Create `modules/development/ai-agents.nix`
- Expose as `flake.modules.homeManager.aiAgents`
- Install `opencode` package
- Configure `programs.claude-code` with `theme = "dark"`
- Import into erebor HM config

### FR-2: firefox HM module
- Create `modules/desktop/firefox.nix` (HM section)
- Expose as `flake.modules.homeManager.firefox`
- Configure `xdg.mimeApps` with firefox as default for http/https/text/html/about/unknown
- Configure `programs.firefox` with default profile: ddg search, vertical tabs, no saved logins, cache disabled, workspace management disabled

> import into the erebor homeManager config

### FR-3: firefox NixOS module
- Add `flake.modules.nixos.firefox` to the same `modules/desktop/firefox.nix` file
- Port all policies from source `modules/nixos/firefox.nix`: disable telemetry, pocket, studies; content blocking strict; AI controls blocked; extensions: uBlock0, LastPass, SponsorBlock, Raindrop.io
- Import into erebor NixOS config

### FR-4: devops module
- Create `modules/development/devops.nix`
- Expose as `flake.modules.homeManager.devops`
- **Flat module** (no `myModules.*` options): always include all selected tools
- kubernetes toolset: `kubectl`, `k9s`, `kubectx`, `kustomize`, `cmctl`, `kubernetes-helm`
- terraform toolset: `tenv`, `tflint`
- AWS toolset: `aws-sso-util`
- certificates toolset: `step-cli`
- Shell aliases: `k=kubectl`, `kns=kubens`, `kctx=kubectx`
- Import into erebor HM config

### FR-5: spotify-player module
- Create `modules/desktop/spotify-player.nix`
- Expose as `flake.modules.homeManager.spotifyPlayer`
- Enable `programs.spotify-player`
- Import into erebor HM config

### FR-6: cava module
- Create `modules/desktop/cava.nix`
- Expose as `flake.modules.homeManager.cava`
- Enable `programs.cava` with: mode=normal, sensitivity=70, foreground colour #d79921
- Import into erebor HM config

### FR-7: mpv module
- Create `modules/desktop/mpv.nix`
- Expose as `flake.modules.homeManager.mpv`
- **Flat module** (no `myModules.*` options)
- Configure `programs.mpv` with: uosc + sponsorblock + mpris scripts, wayland support, high-quality profile, best video+audio format
- Import into erebor HM config

### FR-8: erebor host wiring
- Update `modules/hosts/erebor/default.nix`
- Add `firefox` to NixOS imports
- Add `firefox`, `aiAgents`, `devops`, `spotifyPlayer`, `cava`, `mpv` to HM imports

---

## Non-Functional Requirements

- **NFR-1**: All modules follow the `flake.modules.homeManager.<name>` / `flake.modules.nixos.<name>` pattern
- **NFR-2**: No `myModules.*` options pattern used (flat modules only)
- **NFR-3**: `nix flake check` must pass after all changes
- **NFR-4**: No new unfree package declarations needed (all packages are free software)

---

## Extension Configuration

| Extension | Enabled | Decided At |
|---|---|---|
| Security Baseline | No | Requirements Analysis (Session 3) |
| Property-Based Testing | No | Requirements Analysis (Session 3) |
