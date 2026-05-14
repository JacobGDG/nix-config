{
  jg.kitty.homeManager = {config, ...}: {
    programs.kitty = {
      enable = true;

      settings = let
        p = config.theme.palette;
      in {
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

        background = "#${p.base00}";
        foreground = "#${p.base05}";

        selection_background = "#${p.base02}";
        selection_foreground = "#${p.base05}";

        # normal
        color0 = "#${p.base01}";
        color1 = "#${p.base08}";
        color2 = "#${p.base0B}";
        color3 = "#${p.base09}";
        color4 = "#${p.base0D}";
        color5 = "#${p.base0E}";
        color6 = "#${p.base0C}";
        color7 = "#${p.base06}";

        # bright
        color8 = "#${p.base02}";
        color9 = "#${p.base08}";
        color10 = "#${p.base0B}";
        color11 = "#${p.base0A}";
        color12 = "#${p.base0D}";
        color13 = "#${p.base0E}";
        color14 = "#${p.base0C}";
        color15 = "#${p.base07}";
      };
    };
  };
}
