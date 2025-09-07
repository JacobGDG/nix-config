{
  pkgs,
  config,
  lib,
  ...
}: {
  home = {
    packages = [
      pkgs.dunst # notification
    ];

    file."${config.xdg.configHome}/dunst/dunstrc" = {
      text = ''
        [global]
            font = "JetBrainsMono Nerd Font 8"
            frame_color = "#${config.lib.stylix.colors.base05}";
            separator_color = "#${config.lib.stylix.colors.base05}";
            highlight = "#${config.lib.stylix.colors.base0D}";
            corner_radius = 5
            gap_size = 3
            format = "%a\n%s\n%b"

        [urgency_low]
            background = "#${config.lib.stylix.colors.base01}";
            foreground = "#${config.lib.stylix.colors.base03}";
            frame_color = "#${config.lib.stylix.colors.base03}";

        [urgency_normal]
            background = "#${config.lib.stylix.colors.base01}";
            foreground = "#${config.lib.stylix.colors.base05}";
            frame_color = "#${config.lib.stylix.colors.base05}";

        [urgency_critical]
            background = "#${config.lib.stylix.colors.base01}";
            foreground = "#${config.lib.stylix.colors.base08}";
            frame_color = "#${config.lib.stylix.colors.base08}";
      '';
    };
  };
}
