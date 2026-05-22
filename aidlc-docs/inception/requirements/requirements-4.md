# Requirements — Session 4: dconf, udiskie, thunderbird, libreoffice

## Intent Analysis

- **User Request**: Import 4 additional HM modules for the erebor host from `/tmp/nix-config-src`.
- **Request Type**: Enhancement / Module Port (brownfield)
- **Scope Estimate**: 4 new `.nix` files + 1 modified host file
- **Complexity Estimate**: Trivial — all flat modules, no options, patterns fully established
- **Questions file**: Skipped — requirements exceptionally clear and complete; extensions already decided in Session 3 (both disabled)

---

## Functional Requirements

### FR-1: dconf module
- Create `modules/desktop/dconf.nix`
- Expose as `flake.modules.homeManager.dconf`
- Install `adw-gtk3` package
- Set dconf: `color-scheme = "prefer-dark"`, `gtk-theme = "adw-gtk3-dark"`
- Import into erebor HM config

### FR-2: udiskie module
- Create `modules/desktop/udiskie.nix`
- Expose as `flake.modules.homeManager.udiskie`
- Enable `services.udiskie` with dolphin as file manager
- Import into erebor HM config

### FR-3: thunderbird module
- Create `modules/desktop/thunderbird.nix`
- Expose as `flake.modules.homeManager.thunderbird`
- Enable `programs.thunderbird` with empty profiles attrset
- Import into erebor HM config

### FR-4: libreoffice module
- Create `modules/desktop/libreoffice.nix`
- Expose as `flake.modules.homeManager.libreoffice`
- Install `libreoffice-qt`, `hunspell`, `hunspellDicts.en_GB-large`
- Import into erebor HM config

### FR-5: jake user wiring
- Update `modules/jake.nix`
- Add `dconf`, `udiskie`, `thunderbird`, `libreoffice` to jake's HM imports
- Rationale: these are user tools (theming, automount, email, office) that belong to the jake user profile, not host-specific infrastructure

---

## Non-Functional Requirements

- **NFR-1**: All modules follow the `flake.modules.homeManager.<name>` flat pattern
- **NFR-2**: `nix flake check` + `just hm-build` must pass

---

## Extension Configuration

| Extension | Enabled | Decided At |
|---|---|---|
| Security Baseline | No | Session 3 |
| Property-Based Testing | No | Session 3 |
