# Execution Plan — Erebor Full Config Migration (with Jake)

## Detailed Analysis Summary

### Transformation Scope
- **Type**: Brownfield extension — adding new modules to an existing working flake-parts repo
- **Primary Changes**: 15 new .nix files + 5 existing files modified; new `modules/shell/` and `modules/development/` directories
- **Existing Infrastructure**: Untouched — flake.nix, hosts.nix, home-manager.nix, unfree.nix, systems.nix, versions.nix all remain as-is

### Change Impact Assessment
- **User-facing changes**: Yes — jake's full home environment (desktop, shell, dev tools) becomes declarative
- **Structural changes**: Yes — two new module directories (shell/, development/)
- **Data model changes**: No
- **API changes**: No
- **NFR impact**: No

### Risk Assessment
- **Risk Level**: Low — each module is independently declarative; failure in one doesn't break others
- **Rollback Complexity**: Easy — revert individual files; `nix flake check` catches issues early
- **Testing Complexity**: Simple — `nix flake check` + `nixos-rebuild dry-build`

---

## Workflow Visualization

```
INCEPTION PHASE
  [x] Workspace Detection          COMPLETE
  [-] Reverse Engineering          SKIP (done in session 1)
  [x] Requirements Analysis        COMPLETE (21 FRs, 2 revision rounds)
  [-] User Stories                 SKIP (infra config, no personas)
  [>] Workflow Planning            IN PROGRESS
  [-] Application Design           SKIP (no new component boundaries)
  [-] Units Generation             SKIP (single logical unit)

CONSTRUCTION PHASE
  [-] Functional Design            SKIP (direct config port)
  [-] NFR Requirements             SKIP (no new NFRs)
  [-] NFR Design                   SKIP
  [-] Infrastructure Design        SKIP (no cloud/infra changes)
  [ ] Code Generation              EXECUTE
  [ ] Build and Test               EXECUTE

OPERATIONS PHASE
  [ ] Operations                   PLACEHOLDER
```

---

## Phases to Execute

### INCEPTION PHASE
- [x] Workspace Detection — COMPLETE
- [-] Reverse Engineering — SKIP: source analysed in session 1
- [x] Requirements Analysis — COMPLETE
- [-] User Stories — SKIP: infrastructure config, no personas
- [>] Workflow Planning — IN PROGRESS
- [-] Application Design — SKIP: no new component boundaries
- [-] Units Generation — SKIP: single logical unit

### CONSTRUCTION PHASE
- [-] Functional Design — SKIP: direct config port, no new business logic
- [-] NFR Requirements — SKIP: no new NFRs
- [-] NFR Design — SKIP
- [-] Infrastructure Design — SKIP: no cloud infrastructure changes
- [ ] Code Generation — EXECUTE (single unit, 15 new + 5 modified files)
- [ ] Build and Test — EXECUTE

---

## Code Generation Scope

### Files to Create (new)
| # | File | Module Name | FR |
|---|---|---|---|
| 1 | `modules/core/colors.nix` | homeManager.core (colors) | FR-1 |
| 2 | `modules/desktop/waybar.nix` | homeManager.waybar | FR-3 |
| 3 | `modules/desktop/dunst.nix` | homeManager.dunst | FR-4 |
| 4 | `modules/desktop/hypridle.nix` | homeManager.hypridle | FR-5 |
| 5 | `modules/desktop/hyprlock.nix` | homeManager.hyprlock | FR-6 |
| 6 | `modules/desktop/hyprpaper.nix` | homeManager.hyprpaper | FR-7 |
| 7 | `modules/desktop/wlogout.nix` | homeManager.wlogout | FR-8 |
| 8 | `modules/desktop/wofi.nix` | homeManager.wofi | FR-9 |
| 9 | `modules/shell/zsh.nix` | homeManager.zsh | FR-11 |
| 10 | `modules/shell/starship.nix` | homeManager.starship | FR-12 |
| 11 | `modules/shell/tmux.nix` | homeManager.tmux | FR-13 |
| 12 | `modules/shell/sesh.nix` | homeManager.sesh | FR-14 |
| 13 | `modules/shell/tmuxifier.nix` | homeManager.tmuxifier | FR-15 |
| 14 | `modules/development/git.nix` | homeManager.git | FR-16 |
| 15 | `modules/development/neovim.nix` | homeManager.neovim | FR-17 |

### Files to Modify (existing)
| # | File | Change | FR |
|---|---|---|---|
| 16 | `modules/desktop/hyprland.nix` | Expand HM section with full config | FR-2 |
| 17 | `modules/desktop/terminal.nix` | Expand kitty config | FR-10 |
| 18 | `modules/core/home-manager.nix` | Add news.display = "silent" | FR-18 |
| 19 | `modules/jake.nix` | Add packages/programs; remove jake@erebor stub | FR-19 |
| 20 | `modules/hosts/erebor/default.nix` | Add jake@erebor module with imports + packages | FR-21 |

### Files Unchanged
| File | Reason |
|---|---|
| `modules/hosts/erebor/users.nix` | Already correct — FR-20 requires no changes |
| All `modules/flake/*` | No changes needed |
| `modules/system/nvidia.nix` | No changes needed |
| `modules/core/shells.nix`, `security.nix`, etc. | No changes needed |

---

## Success Criteria
- **Primary Goal**: `jake@erebor` fully declared; all desktop/shell/dev tools in purpose-built single-responsibility modules
- **Key Deliverables**: 15 new modules + 5 modified files
- **Quality Gates**: `nix flake check` passes; no evaluation errors
