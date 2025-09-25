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
    home.packages = with pkgs; [
      nvim-pkg
    ];
  };
}
