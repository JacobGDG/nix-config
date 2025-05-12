{pkgs, ...}: {
  wayland.windowManager.hyprland = {
    plugins = [
      pkgs.hyprlandPlugins.hyprbars
    ];
    settings = {
      "plugin:hyprbars" = {
        # example config
        bar_height = 20;
        bar_text_font = "JetBrainsMono Nerd Font";
        bar_text_size = 12;
        bar_part_of_window = true;
        bar_precedence_over_border = true;

        hyprbars-button = [
          "rgb(ff4040), 10, 󰖭, hyprctl dispatch killactive"
          "rgb(eeee11), 10, , hyprctl dispatch fullscreen 1"
        ];
      };
    };
  };
}
