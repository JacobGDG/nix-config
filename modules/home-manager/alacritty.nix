{ inputs, ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "xterm-256color";

      general.import = [ "${inputs.alacritty-themes}/themes/gruvbox_material_medium_dark.toml" ];

      terminal = {
        shell = {
          program = "/bin/zsh";
          # args = [ "-l" "-c" "tmux attach || tmux new -s home" ];
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
          family = "Menlo";
          style = "Regular";
        };
        bold = {
          family = "Menlo";
          style = "Bold";
        };
        italic = {
          family = "Menlo";
          style = "Italic";
        };
        size = 10;
      };
    };
  };
}
