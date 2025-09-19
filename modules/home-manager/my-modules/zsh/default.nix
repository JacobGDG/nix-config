{
  lib,
  mylib,
  ...
}: {
  options = {
    myModules.zsh = {
      enable = lib.mkEnableOption "zsh";
      extraAliases = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = {};
        description = "Extra shell aliases to add to zsh configuration.";
      };

      starship = {
        enable = lib.mkEnableOption "starship";
      };
    };
  };

  imports = mylib.scanPaths ./.;
}

