{
  flake.modules.homeManager.hypridle = {
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock";
          before_sleep_cmd = "pidof hyprlock || hyprlock";
          after_sleep_cmd = "hyprctl dispatch 'hl.dsp.dpms(on)";
        };

        listener = [
          {
            timeout = 300;
            on-timeout = "pidof hyprlock || hyprlock";
          }
          {
            timeout = 420;
            on-timeout = "hyprctl dispatch 'hl.dsp.dpms(off)'";
            on-resume = "hyprctl dispatch 'hl.dsp.dpms(on)'";
          }
          {
            timeout = 600;
            on-timeout = "systemctl suspend";
          }
        ];
      };
    };
  };
}
