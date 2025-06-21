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
            frame_color = "#${config.colorScheme.palette.base05}";
            separator_color = "#${config.colorScheme.palette.base05}";
            highlight = "#${config.colorScheme.palette.base0D}";
            corner_radius = 5
            gap_size = 3
            format = "%a\n%s\n%b"

        [urgency_low]
            background = "#${config.colorScheme.palette.base01}";
            foreground = "#${config.colorScheme.palette.base03}";
            frame_color = "#${config.colorScheme.palette.base03}";

        [urgency_normal]
            background = "#${config.colorScheme.palette.base01}";
            foreground = "#${config.colorScheme.palette.base05}";
            frame_color = "#${config.colorScheme.palette.base05}";

        [urgency_critical]
            background = "#${config.colorScheme.palette.base01}";
            foreground = "#${config.colorScheme.palette.base08}";
            frame_color = "#${config.colorScheme.palette.base08}";
      '';
    };
  };
}
