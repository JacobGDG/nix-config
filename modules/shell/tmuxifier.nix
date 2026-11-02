{
  flake.modules.homeManager.tmuxifier = {
    config,
    pkgs,
    ...
  }: {
    home = {
      packages = [pkgs.tmuxifier];

      sessionVariables.TMUXIFIER_LAYOUT_PATH = "${config.xdg.configHome}/tmux/layouts";
    };

    xdg.configFile."tmux/layouts/vimsplit.window.sh".text = ''
      window_root $PWD
      new_window "Editor"
      run_cmd " nvim -c \"FzfLua files\""
      split_v 20
      run_cmd " git fetch"
    '';

    xdg.configFile."tmux/layouts/music.window.sh".text = ''
      new_window "Music"
      run_cmd " spotify_player"
      split_v 20
      run_cmd "cava"
      select_pane 1
    '';

    # Usage: K9S_NAMESPACE=<namespace> tmuxifier load-window k9s-ns-deployments
    xdg.configFile."tmux/layouts/k9s-ns-deployments.window.sh".text = ''
      namespace="''${K9S_NAMESPACE:?set K9S_NAMESPACE to the namespace to watch}"
      new_window "k9s $namespace"
      run_cmd " k9s -n $namespace -c pods"
      split_v 50
      run_cmd " k9s -n $namespace -c deployments"
      select_pane 1
    '';
  };
}
