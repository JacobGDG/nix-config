{
  pkgs,
  config,
  ...
}: {
  home.packages = [
    pkgs.dunst # notification
  ];

  home.file."${config.xdg.configHome}/dunst/dunstrc" = {
    text = ''
      [global]
          font = "JetBrainsMono Nerd Font 8"
          frame_color = "#${config.colorScheme.palette.base05}";
          separator_color = "#${config.colorScheme.palette.base05}";
          highlight = "#${config.colorScheme.palette.base0D}";
          corner_radius = 5

      [urgency_low]
          background = "#${config.colorScheme.palette.base01}";
          foreground = "#${config.colorScheme.palette.base03}";

      [urgency_normal]
          background = "#${config.colorScheme.palette.base02}";
          foreground = "#${config.colorScheme.palette.base05}";

      [urgency_critical]
          background = "#${config.colorScheme.palette.base08}";
          foreground = "#${config.colorScheme.palette.base05}";
    '';
  };
}
