{
  flake.modules.homeManager.sesh = {pkgs, ...}: let
    tmux-sesh-open = pkgs.writeScriptBin "tmux-sesh-open" ''
      #!/usr/bin/env bash
      sesh connect "$(
        sesh list --icons | rg -v quick-access-kitty | fzf --tmux 55%,60% \
          --no-sort --ansi --border-label ' sesh ' --prompt '⚡  ' \
          --header '  ^a all ^t tmux ^g configs ^x zoxide ^d tmux kill ^f find' \
          --bind 'tab:down,btab:up' \
          --bind 'ctrl-a:change-prompt(⚡  )+reload(sesh list --icons)' \
          --bind 'ctrl-t:change-prompt(🪟  )+reload(sesh list -t --icons)' \
          --bind 'ctrl-g:change-prompt(⚙️  )+reload(sesh list -c --icons)' \
          --bind 'ctrl-x:change-prompt(📁  )+reload(sesh list -z --icons)' \
          --bind 'ctrl-f:change-prompt(🔎  )+reload(fd -H -d 2 -t d -E .Trash . ~)' \
          --bind 'ctrl-d:execute(tmux kill-session -t {2..})+change-prompt(⚡  )+reload(sesh list --icons)' \
          --preview 'sesh preview {}'
      )"
    '';
  in {
    home.packages = [
      pkgs.sesh
      tmux-sesh-open
    ];

    programs.tmux.extraConfig = ''
      unbind s
      bind-key s run-shell tmux-sesh-open
    '';

    xdg.configFile."sesh/sesh.toml".source = (pkgs.formats.toml {}).generate "sesh.toml" {
      default_session.startup_command = "tmuxifier load-window vimsplit && tmux move-window -t 0 && tmux kill-window -t 1";
      session = [
        {
          name = "NixConfig";
          path = "~/src/nix-config/main/";
          startup_command = "tmuxifier load-window vimsplit && tmux move-window -t 0 && tmux kill-window -t 1";
        }
        {
          name = "Pomodoro";
          path = "~";
          startup_command = "tomato";
        }
      ];
    };
  };
}
