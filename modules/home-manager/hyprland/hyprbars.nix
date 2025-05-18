{
  pkgs,
  config,
  ...
}: {
  wayland.windowManager.hyprland = {
    plugins = [
      pkgs.hyprlandPlugins.hyprbars
    ];
    settings = {
      "plugin:hyprbars" = {
        # example config
        bar_height = 20;
        bar_text_font = "JetBrainsMono NF";
        bar_text_size = 10;
        bar_part_of_window = true;
        bar_precedence_over_border = true;

        bar_color = "rgb(${config.colorScheme.palette.base01})";
        "col.text" = "rgb(${config.colorScheme.palette.base05})";

        hyprbars-button = [
          "rgb(${config.colorScheme.palette.base08}), 10, 󰖭, hyprctl dispatch killactive"
          "rgb(${config.colorScheme.palette.base09}), 10, , hyprctl dispatch fullscreen 2"
        ];
      };
    };
  };
}
