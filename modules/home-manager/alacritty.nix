{inputs, ...}: {
  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "xterm-256color";

      general.import = ["${inputs.alacritty-themes}/themes/gruvbox_material_medium_dark.toml"];

      terminal = {
        shell = {
          program = "zsh";
          args = ["-l" "-c" "tmux attach || tmux new -s home"];
        };
      };

      window.padding = {
        x = 1;
        y = 1;
      };
      scrolling = {
        history = 10000;
      };
      font = {
        normal = {
          family = "Fira Code";
          style = "Regular";
        };
        bold = {
          family = "Fira Code";
          style = "Bold";
        };
        italic = {
          family = "Fira Code";
          style = "Italic";
        };
        size = 10;
      };
    };
  };
}
