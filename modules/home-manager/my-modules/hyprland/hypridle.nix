{
  config,
  lib,
  ...
}: let
  cfg = config.myModules.hyprland.hypridle;
in {
  config = lib.mkIf cfg.enable {
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock";
          before_sleep_cmd = "pidof hyprlock || hyprlock";
          after_sleep_cmd = "hyprctl dispatch dpms on";
        };

        listener = [
          # Lock the screen
          {
            timeout = 300;
            on-timeout = "pidof hyprlock || hyprlock";
          }
          # Turn off screen
          {
            timeout = cfg.auto_screenoff_timeout;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
          # Suspend the system
          {
            timeout = cfg.auto_suspend_timeout;
            on-timeout = "systemctl suspend";
          }
        ];
      };
    };
  };
}
