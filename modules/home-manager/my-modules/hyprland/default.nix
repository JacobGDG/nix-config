{
  mylib,
  lib,
  config,
  inputs,
  ...
}: let
  base-enabled = config.myModules.hyprland.enable;
in {
  options = {
    myModules.hyprland = {
      enable = lib.mkEnableOption "hyprland";
      waybar = {enable = mylib.mkEnableOptionWithDefault "waybar" base-enabled;};
      hypridle = {enable = mylib.mkEnableOptionWithDefault "hypridle" base-enabled;};
      wlogout = {enable = mylib.mkEnableOptionWithDefault "wlogout" base-enabled;};
      wofi = {enable = mylib.mkEnableOptionWithDefault "wofi" base-enabled;};
      dunst = {enable = mylib.mkEnableOptionWithDefault "dunst" base-enabled;};
      hyprlock = {
        enable = mylib.mkEnableOptionWithDefault "hyprlock" base-enabled;
        wallpaper_path = lib.mkOption {type = lib.types.string;};
      };
      hyprpaper = {
        enable = mylib.mkEnableOptionWithDefault "hyprpaper" base-enabled;
        wallpaper_path = lib.mkOption {type = lib.types.string;};
      };
    };
  };

  imports = mylib.scanPaths ./.;
}
