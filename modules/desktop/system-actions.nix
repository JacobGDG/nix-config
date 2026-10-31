{
  flake.modules.homeManager.systemActions = {pkgs, ...}: let
    mkAction = name: icon: text: {
      inherit name icon;
      exec = "${pkgs.writeShellScript "system-action" text}";
      terminal = false;
      categories = ["System"];
    };
  in {
    xdg.desktopEntries = {
      system-shutdown = mkAction "Shutdown" "system-shutdown" ''
        uwsm-app -- hyprshutdown -t 'Shutting down...' --post-cmd 'systemctl poweroff'
      '';
      system-reboot = mkAction "Reboot" "system-reboot" ''
        uwsm-app -- hyprshutdown -t 'Rebooting...' --post-cmd 'systemctl reboot'
      '';
      system-logout = mkAction "Log Out" "system-log-out" ''
        uwsm-app -- hyprshutdown -t 'Logging out...'
      '';
      system-sleep = mkAction "Sleep" "system-suspend" "systemctl sleep";

      system-lock = mkAction "Lock" "system-lock-screen" "loginctl lock-session";

      clipboard-clear = mkAction "Clear Clipboard" "edit-clear" ''
        cliphist wipe
        wl-copy --clear
        notify-send -a 'Clipboard' 'Clipboard cleared'
      '';

      wifi-on = mkAction "Wi-Fi On" "network-wireless-on" ''
        nmcli radio wifi on
        notify-send -a 'Wi-Fi' 'Wi-Fi enabled'
      '';
      wifi-off = mkAction "Wi-Fi Off" "network-wireless-off" ''
        nmcli radio wifi off
        notify-send -a 'Wi-Fi' 'Wi-Fi disabled'
      '';
      wifi-networks = mkAction "Wi-Fi Networks" "network-wireless" "networkmanager_dmenu";
    };
  };
}
