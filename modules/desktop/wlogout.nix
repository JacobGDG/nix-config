{
  flake.modules.homeManager.wlogout = {
    programs.wlogout = {
      enable = true;
      layout = [
        {
          label = "shutdown";
          action = "uwsm-app -- hyprshutdown -t 'Shutting down...' --post-cmd 'systemctl poweroff'";
          text = "Shutdown";
          keybind = "s";
        }
        {
          label = "lock";
          action = "sleep 0.1 && hyprlock";
          text = "Lock";
          keybind = "l";
        }
        {
          label = "reboot";
          action = "uwsm-app -- hyprshutdown -t 'Rebooting...' --post-cmd 'systemctl reboot'";
          text = "Reboot";
          keybind = "r";
        }
        {
          label = "suspend";
          action = "sleep 1 && systemctl sleep";
          text = "Sleep";
        }
        {
          label = "logout";
          action = "uwsm-app -- hyprshutdown -t 'Logging out...'";
          text = "Logout";
        }
      ];
    };
  };
}
