{config, ...}: {
  programs.kitty = {
    enable = true;

    settings = {
      font_size = 8;
      font_family = "JetBrainsMono NF";
      copy_on_select = "yes";
      cursor_shape = "block";
      cursor_blink_interval = 0;
      enable_audio_bell = "no";
      shell = "zsh";
      editor = "nvim";
      window_padding_width = 0;
      enabled_layouts = "vertical";
      confirm_os_window_close = 0;

      background = "#${config.lib.stylix.colors.base00}";
      foreground = "#${config.lib.stylix.colors.base05}";

      selection_background = "#${config.lib.stylix.colors.base02}";
      selection_foreground = "#${config.lib.stylix.colors.base05}";

      color0 = "#${config.lib.stylix.colors.base01}";
      color1 = "#${config.lib.stylix.colors.base08}";
      color2 = "#${config.lib.stylix.colors.base0B}";
      color3 = "#${config.lib.stylix.colors.base09}";
      color4 = "#${config.lib.stylix.colors.base0D}";
      color5 = "#${config.lib.stylix.colors.base0E}";
      color6 = "#${config.lib.stylix.colors.base0C}";
      color7 = "#${config.lib.stylix.colors.base06}";

      # bright
      color8 = "#${config.lib.stylix.colors.base02}";
      color9 = "#${config.lib.stylix.colors.base08}";
      color10 = "#${config.lib.stylix.colors.base0B}";
      color11 = "#${config.lib.stylix.colors.base0A}";
      color12 = "#${config.lib.stylix.colors.base0D}";
      color13 = "#${config.lib.stylix.colors.base0E}";
      color14 = "#${config.lib.stylix.colors.base0C}";
      color15 = "#${config.lib.stylix.colors.base07}";
    };
  };
}
