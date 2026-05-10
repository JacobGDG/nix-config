# nix-config

## Debugging

### How to view includes on an aspect

`jg` and `den` are not exposed by default. `modules/_debug.nix` is committed but excluded from import-tree via the `_` prefix.

To activate it:

```bash
just debug-file   # copies _debug.nix → debug.nix and stages it
just debug-clean  # removes debug.nix when done
```

Then in the repl:

```bash
nix repl
:lf .
map (a: a.name or "?") jg.tui.includes
builtins.attrNames jg
```
