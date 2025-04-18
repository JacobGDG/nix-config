{inputs, ...}: {
  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "xterm-256color";

      general.import = ["${inputs.alacritty-themes}/themes/gruvbox_dark.toml"];

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
          family = "JetBrainsMono NF";
          style = "Regular";
        };
        bold = {
          family = "JetBrainsMono NF";
          style = "Bold";
        };
        italic = {
          family = "JetBrainsMono NF";
          style = "Italic";
        };
        size = 8;
      };
    };
  };
}
