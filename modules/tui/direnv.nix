{jg, ...}: {
  jg.tui.includes = [jg.direnv];

  jg.direnv.homeManager = {pkgs, ...}: {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      package = pkgs.direnv.overrideAttrs (_old: {doCheck = false;}); # https://github.com/NixOS/nixpkgs/issues/507531
      stdlib = ''
        : ''${XDG_CACHE_HOME:=$HOME/.cache}
        declare -A direnv_layout_dirs
        direnv_layout_dir() {
          echo "''${direnv_layout_dirs[$PWD]:=$(
            echo -n "$XDG_CACHE_HOME"/direnv/layouts/
            echo -n "$PWD" | sha1sum | cut -d ' ' -f 1
          )}"
        }
      '';
    };
  };
}
