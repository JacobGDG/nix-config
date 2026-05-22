# Execution Plan — Session 4: dconf, udiskie, thunderbird, libreoffice

## Analysis Summary

- **Type**: Brownfield extension — 4 trivial flat HM modules
- **Primary Changes**: 4 new `.nix` files + 1 existing host file modified
- **Risk Level**: Low
- **Rollback**: Easy — revert individual files

## Workflow

```
INCEPTION:    WD ✓  RE skip  RA ✓  US skip  WP ✓  AppDesign skip  Units skip
CONSTRUCTION: FD skip  NFR skip  NFR Design skip  Infra skip  Code Gen EXECUTE  Build+Test EXECUTE
OPERATIONS:   placeholder
```

## File Change Sequence

| # | File | Action | Module |
|---|------|--------|--------|
| 1 | `modules/desktop/dconf.nix` | CREATE | `dconf` (HM) |
| 2 | `modules/desktop/udiskie.nix` | CREATE | `udiskie` (HM) |
| 3 | `modules/desktop/thunderbird.nix` | CREATE | `thunderbird` (HM) |
| 4 | `modules/desktop/libreoffice.nix` | CREATE | `libreoffice` (HM) |
| 5 | `modules/jake.nix` | MODIFY | wire all 4 imports |

## Success Criteria
- `nix flake check` passes
- `just hm-build` passes
