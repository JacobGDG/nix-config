{
  config,
  lib,
  mylib,
  pkgs,
  ...
}: let
  cfg = config.myModules.nvim;
in {
  options = {
    myModules.nvim = {
      enable = lib.mkEnableOption "neovim";
    };
  };

  config = lib.mkIf cfg.enable {
    home = {
      sessionVariables.EDITOR = "nvim";
      packages = with pkgs; [
        nvim-pkg
      ];
    };
  };
}
