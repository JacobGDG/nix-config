{
  programs.wlogout = {
    enable = true;
    layout = [
      {
        label = "shutdown";
        action = "systemctl poweroff";
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
        action = "sleep 1 && systemctl reboot";
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
        action = "sleep 1 && hyprctl dispatch exit";
        text = "Logout";
      }
    ];
  };
}
