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

## Custom packages / scripts

Custom shell scripts and packages live in `modules/packages/`. They are exposed as a nixpkgs overlay applied to all home-manager configs via `den.default.homeManager`, so `pkgs.<name>` works anywhere.

**Adding a new script:**

1. Drop a `.sh` file in `modules/packages/`
2. Add a `writeShellApplication` entry in `modules/packages/default.nix` with explicit `runtimeInputs`
3. Install it where needed: `home.packages = [ pkgs.my-script ]`

```nix
# modules/packages/default.nix
my-script = prev.writeShellApplication {
  name = "my-script";
  runtimeInputs = with prev; [curl jq];
  text = builtins.readFile ./my-script.sh;
};
```

A pre-commit hook (`just check-scripts`) ensures every `.sh` in `modules/packages/` is referenced in `default.nix`.

## Theming

Colours are centralised in `modules/theming/`. Each theme is a `jg.<name>` aspect that declares and sets a `theme.palette` home-manager option (base16 attrset of hex strings without `#`).

The active theme is included in `me.nix`:

```nix
den.aspects.jake.includes = [
  jg.gruvbox  # swap this to change theme
  ...
];
```

Aspects that need colours read from `config.theme.palette`:

```nix
jg.kitty.homeManager = {config, ...}: {
  programs.kitty.settings.background = "#${config.theme.palette.base00}";
};
```

To add a new theme, create `modules/theming/<name>.nix` following the same pattern as `gruvbox.nix` and swap the include in `me.nix`.
