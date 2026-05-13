{
  den.default.homeManager = {
    nixpkgs.overlays = [
      (final: prev: {
        hyprctl-conditional-quit = prev.writeShellApplication {
          name = "hyprctl-conditional-quit";
          runtimeInputs = with prev; [hyprland jq libnotify];
          text = ''
            active_window=$(hyprctl activewindow -j | jq -r '.class')
            if [[ $active_window =~ ^(steam_app_[0-9]+|dwarfort|Minecraft.+)$ ]]; then
              notify-send -a "Safe Exit" "Canceled exit call, use app UI."
              exit 1
            fi
            hyprctl dispatch killactive
          '';
        };

        media-control = prev.writeShellApplication {
          name = "media-control";
          runtimeInputs = with prev; [pulseaudio brightnessctl playerctl libnotify wget];
          text = builtins.readFile ./media-control.sh;
        };

        quick-access-kitty = prev.writeShellApplication {
          name = "quick-access-kitty";
          runtimeInputs = with prev; [hyprland jq kitty];
          text = builtins.readFile ./quick-access-kitty.sh;
        };

        wofi-bookmarks = prev.writeShellApplication {
          name = "wofi-bookmarks";
          runtimeInputs = with prev; [ripgrep jq wofi xdg-utils];
          text = builtins.readFile ./wofi-bookmarks.sh;
        };

        show-keymaps = prev.writeShellApplication {
          name = "show-keymaps";
          runtimeInputs = with prev; [gnugrep gnused wofi];
          text = builtins.readFile ./show-keymaps.sh;
        };
      })
    ];
  };
}
