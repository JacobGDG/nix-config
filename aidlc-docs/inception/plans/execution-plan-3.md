# Execution Plan — Session 3: Additional Erebor Modules

## Detailed Analysis Summary

### Transformation Scope
- **Type**: Brownfield extension — porting 6 HM modules + 1 NixOS module to the new repo
- **Primary Changes**: 7 new `.nix` files + 1 existing host file modified
- **New directories**: None (placing in existing `modules/development/` and `modules/desktop/`)
- **Existing Infrastructure**: Untouched

### Change Impact Assessment
- **User-facing changes**: Yes — new tools and programs available in erebor's HM environment
- **Structural changes**: No — uses established module directory structure
- **Data model changes**: No
- **API changes**: No
- **NFR impact**: No

### Risk Assessment
- **Risk Level**: Low — each module is independently declarative; `nix flake check` catches issues early
- **Rollback Complexity**: Easy — revert individual files
- **Testing Complexity**: Simple — `nix flake check` + `nixos-rebuild dry-build`

---

## Workflow Visualization

```
INCEPTION PHASE
  [x] Workspace Detection        — COMPLETED
  [ ] Reverse Engineering        — SKIP (source already analysed; patterns clear)
  [x] Requirements Analysis      — COMPLETED
  [ ] User Stories               — SKIP (infrastructure config, no user personas)
  [x] Workflow Planning          — IN PROGRESS
  [ ] Application Design         — SKIP (no new architectural components)
  [ ] Units Generation           — SKIP (7 parallel independent files, no dependencies)

CONSTRUCTION PHASE
  [ ] Functional Design          — SKIP (config porting, no complex business logic)
  [ ] NFR Requirements           — SKIP (no NFRs beyond nix flake check)
  [ ] NFR Design                 — SKIP
  [ ] Infrastructure Design      — SKIP
  [>] Code Generation            — EXECUTE
  [ ] Build and Test             — EXECUTE

OPERATIONS PHASE
  [ ] Operations                 — PLACEHOLDER
```

---

## Phases to Execute

### INCEPTION PHASE
- [x] Workspace Detection — COMPLETED
- [ ] Reverse Engineering — SKIP: source repo already analysed in Sessions 1 & 2; patterns fully established
- [x] Requirements Analysis — COMPLETED
- [ ] User Stories — SKIP: infrastructure Nix config, no user personas needed
- [x] Workflow Planning — IN PROGRESS
- [ ] Application Design — SKIP: no new architectural components; all modules follow established `flake.modules.homeManager.*` pattern
- [ ] Units Generation — SKIP: 7 independent files with no inter-dependencies; can be written in a single code generation pass

### CONSTRUCTION PHASE
- [ ] Functional Design — SKIP: straightforward config porting with no novel business logic
- [ ] NFR Requirements — SKIP: no new NFRs; existing `nix flake check` gate is sufficient
- [ ] NFR Design — SKIP: follows from NFR Requirements skip
- [ ] Infrastructure Design — SKIP: no infrastructure changes
- [ ] Code Generation — EXECUTE (always): 7 new module files + 1 file modification
- [ ] Build and Test — EXECUTE (always): `nix flake check` verification

### OPERATIONS PHASE
- [ ] Operations — PLACEHOLDER

---

## File Change Sequence

All 7 new files are independent; creation order does not matter.

| # | File | Action | Module Name |
|---|------|--------|-------------|
| 1 | `modules/development/ai-agents.nix` | CREATE | `aiAgents` (HM) |
| 2 | `modules/desktop/firefox.nix` | CREATE | `firefox` (HM + NixOS) |
| 3 | `modules/development/devops.nix` | CREATE | `devops` (HM) |
| 4 | `modules/desktop/spotify-player.nix` | CREATE | `spotifyPlayer` (HM) |
| 5 | `modules/desktop/cava.nix` | CREATE | `cava` (HM) |
| 6 | `modules/desktop/mpv.nix` | CREATE | `mpv` (HM) |
| 7 | `modules/hosts/erebor/default.nix` | MODIFY | wire all imports |

---

## Success Criteria
- **Primary Goal**: All 6 modules available and imported for erebor
- **Key Deliverables**: 7 `.nix` files (6 new modules + 1 modified host config)
- **Quality Gate**: `nix flake check` passes with no errors
