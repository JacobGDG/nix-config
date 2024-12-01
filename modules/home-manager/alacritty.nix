{ inputs, ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "xterm-256color";

      general.import = [ "${inputs.alacritty-themes}/themes/gruvbox_material_medium_dark.toml" ];

      terminal = {
        shell = {
          program = "zsh";
          args = [ "-l" "-c" "tmux attach || tmux new -s home" ];
        };
      };

      window.padding = {
        x=1;
        y=1;
      };
      scrolling = {
        history = 10000;
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
