{ inputs, ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "xterm-256color";

      import = [ "${inputs.alacritty-themes}/themes/gruvbox_material_medium_dark.toml" ];

      window.padding = {
        x = 10;
        y=10;
      };
      scrolling = {
        history = 10000;
      };
      shell = {
        program = "zsh";
        args = [ "-l" "-c" "tmux attach || tmux new -s home" ];
      };
      font = {
        normal = {
          family = "JetBrains Mono Nerd Font";
          style = "Regular";
        };
        bold = {
          family = "JetBrains Mono Nerd Font";
          style = "Bold";
        };
        italic = {
          family = "JetBrains Mono Nerd Font";
          style = "Italic";
        };
        size = 8;
      };
  
    };
  };
}
