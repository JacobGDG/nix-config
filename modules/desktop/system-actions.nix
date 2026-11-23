{
  flake.modules.homeManager.systemActions = {pkgs, ...}: let
    toml = pkgs.formats.toml {};

    mkAction = text: icon: script: {
      inherit text icon;
      value = "${pkgs.writeShellScript "system-action" script}";
    };
  in {
    # an elephant menu rather than desktop entries, so walker only lists these
    # once you type (its empty query only shows desktopapplications)
    xdg.configFile."elephant/menus/system.toml".source = toml.generate "elephant-menu-system" {
      name = "system";
      name_pretty = "System";
      icon = "applications-system";
      action = "%VALUE%";

      entries = [
        (mkAction "Shutdown" "system-shutdown" ''
          uwsm-app -- hyprshutdown -t 'Shutting down...' --post-cmd 'systemctl poweroff'
        '')
        (mkAction "Reboot" "system-reboot" ''
          uwsm-app -- hyprshutdown -t 'Rebooting...' --post-cmd 'systemctl reboot'
        '')
        (mkAction "Log Out" "system-log-out" ''
          uwsm-app -- hyprshutdown -t 'Logging out...'
        '')
        (mkAction "Sleep" "system-suspend" "systemctl sleep")

        (mkAction "Lock" "system-lock-screen" "loginctl lock-session")

        (mkAction "Clear Clipboard" "edit-clear" ''
          elephant activate "clipboard;;remove_all;;"
          wl-copy --clear
          notify-send -a 'Clipboard' 'Clipboard cleared'
        '')

        (mkAction "Wi-Fi On" "network-wireless-on" ''
          nmcli radio wifi on
          notify-send -a 'Wi-Fi' 'Wi-Fi enabled'
        '')
        (mkAction "Wi-Fi Off" "network-wireless-off" ''
          nmcli radio wifi off
          notify-send -a 'Wi-Fi' 'Wi-Fi disabled'
        '')
        (mkAction "Wi-Fi Networks" "network-wireless" "networkmanager_dmenu")
      ];
    };
  };
}
