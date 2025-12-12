{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.myModules.tmux.tmuxifier;
in {
  config = lib.mkIf cfg.enable {
    home = {
      packages = [pkgs.tmuxifier];

      sessionVariables = {
        TMUXIFIER_LAYOUT_PATH = "${config.xdg.configHome}/tmux/layouts";
      };
    };

    xdg.configFile."tmux/layouts/vimsplit.window.sh" = {
      text = ''
        window_root $PWD
        new_window "Editor"
        run_cmd "nvim -c \"FzfLua files\""
        split_v 20
        run_cmd "git fetch"
      '';
    };
    xdg.configFile."tmux/layouts/music.window.sh" = {
      text = ''
        new_window "Music"
        run_cmd "spotify_player"
        split_v 20
        run_cmd "cava"
        select_pane 1
      '';
    };
  };
}
