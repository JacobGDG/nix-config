{
  config,
  lib,
  ...
}: let
  cfg = config.myModules.nixOS.hyprland;
in {
  options.myModules.nixOS.hyprland.enable = lib.mkEnableOption "Hyprland";

  config = lib.mkIf cfg.enable {
    services.displayManager = {
      sddm = {
        enable = true;
        wayland = {
          enable = true;
        };
      };
    };

    # Allow hyprlock to perform auth
    security.pam.services.hyprlock.enable = true;

    programs = {
      hyprlock.enable = true;

      uwsm = {
        enable = true;
        waylandCompositors = {
          hyprland = {
            prettyName = "Hyprland";
            comment = "Hyprland compositor managed by UWSM";
            binPath = "/run/current-system/sw/bin/Hyprland";
          };
        };
      };

      hyprland = {
        enable = true;
        withUWSM = true;
      };
    };
  };
}
