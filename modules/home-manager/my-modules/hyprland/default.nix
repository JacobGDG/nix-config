{
  config,
  lib,
  mylib,
  pkgs,
  ...
}: let
  cfg = config.myModules.hyprland;
in {
  options = {
    myModules.hyprland = {
      enable = lib.mkEnableOption "Whether to enable hyprland and many related systems.";
    };
  };

  config = {};

  imports = mylib.scanPaths ./.;
}
