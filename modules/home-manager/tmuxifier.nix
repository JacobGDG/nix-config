{ pkgs, ... }:
let
  layoutDir = "tmux/layouts";
in {
  home = {
    packages = [ pkgs.tmuxifier ];

    sessionVariables = {
      TMUXIFIER_LAYOUT_PATH = "\$HOME/.config/${layoutDir}";
    };
  };

  xdg.configFile."tmux/layouts/vimsplit.window.sh" = {
    text = ''
      window_root $PWD
      new_window "Editor"
      run_cmd "nvim -c \"Telescope find_files\""
      split_v 20
      select_pane 1
    '';
  };
}
