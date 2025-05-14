{
  programs.kitty = {
    enable = true;

    themeFile = "GruvboxMaterialDarkMedium";

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
    };
  };
}
