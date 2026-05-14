{jg, ...}: {
  jg.hyprland.includes = [jg.dunst];

  jg.dunst.homeManager = {
    config,
    pkgs,
    ...
  }: let
    p = config.theme.palette;
  in {
    home.packages = [pkgs.dunst];

    home.file."${config.xdg.configHome}/dunst/dunstrc".text = ''
      [global]
          font = "JetBrainsMono Nerd Font 8"
          frame_color = "#${p.base05}";
          separator_color = "#${p.base05}";
          highlight = "#${p.base0D}";
          corner_radius = 5
          gap_size = 3
          format = "%a\n%s\n%b"

      [urgency_low]
          background = "#${p.base01}";
          foreground = "#${p.base03}";
          frame_color = "#${p.base03}";

      [urgency_normal]
          background = "#${p.base01}";
          foreground = "#${p.base05}";
          frame_color = "#${p.base05}";

      [urgency_critical]
          background = "#${p.base01}";
          foreground = "#${p.base08}";
          frame_color = "#${p.base08}";
    '';
  };
}
