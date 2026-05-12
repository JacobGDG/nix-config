{jg, ...}: let
  # Gruvbox dark palette (base16)
  bg = "504945"; # base02
  bg-dark = "3c3836"; # base01
  bg-darker = "282828"; # base00
  fg = "d5c4a1"; # base05
  fg-dim = "665c54"; # base03
in {
  jg.tui.includes = [jg.tmux];

  jg.tmux.homeManager = {
    config,
    pkgs,
    lib,
    ...
  }: let
    other-pane = pkgs.writeScriptBin "tmux-other-pane" ''
      #!/usr/bin/env bash

      # Ensure we're inside tmux
      if [ -z "$TMUX" ]; then
        echo "Not inside a tmux session"
        exit 1
      fi

      current_pane=$(tmux display-message -p "#{pane_index}")
      all_panes=($(tmux list-panes -F "#{pane_index}"))

      if [ "''${#all_panes[@]}" -ne 2 ]; then
        echo "Error: This script only works when there are exactly 2 panes in the window" >&2
        exit 2
      fi

      for pane in "''${all_panes[@]}"; do
        if [[ "$pane" != "$current_pane" ]]; then
          echo "$pane"
          exit 0
        fi
      done

      echo "UNKNOWN ERROR"
      exit 3
    '';

    sesh-open = pkgs.writeScriptBin "tmux-sesh-open" ''
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
      pkgs.tmuxifier
      other-pane
      sesh-open
    ];

    home.sessionVariables = {
      TMUXIFIER_LAYOUT_PATH = "${config.xdg.configHome}/tmux/layouts";
    };

    xdg.configFile = {
      "sesh/sesh.toml".source = (pkgs.formats.toml {}).generate "sesh.toml" {
        default_session.startup_command = "tmuxifier load-window vimsplit && tmux move-window -t 0 && tmux kill-window -t 1";
        session = [
          {
            name = "NixConfig 󰖷 ";
            path = "~/src/nix-config/main/";
            startup_command = "tmuxifier load-window vimsplit && tmux move-window -t 0 && tmux kill-window -t 1";
          }
          {
            name = "Pomodoro  ";
            path = "~";
            startup_command = "tomato";
          }
        ];
      };

      "tmux/layouts/vimsplit.window.sh".text = ''
        window_root $PWD
        new_window "Editor"
        run_cmd "nvim -c \"FzfLua files\""
        split_v 20
        run_cmd "git fetch"
      '';

      "tmux/layouts/music.window.sh".text = ''
        new_window "Music"
        run_cmd "spotify_player"
        split_v 20
        run_cmd "cava"
        select_pane 1
      '';
    };

    programs.tmux = {
      enable = true;
      keyMode = "vi";
      mouse = true;
      clock24 = true;
      baseIndex = 1;
      prefix = "C-a";
      escapeTime = 10;
      historyLimit = 50000;
      focusEvents = true;
      terminal = "tmux-256color";
      shell = "${pkgs.zsh}/bin/zsh";

      plugins = with pkgs; [
        tmuxPlugins.gruvbox
      ];

      extraConfig = ''
        set -gu default-command
        set -g detach-on-destroy off

        set -g set-titles on
        set -g set-titles-string '#S'

        # -----------------------------------------------------------------------------
        # Key bindings
        # -----------------------------------------------------------------------------

        # Smart pane switching with awareness of Neovim splits
        bind-key -n C-h if -F "#{@pane-is-vim}" 'send-keys C-h' 'select-pane -L'
        bind-key -n C-j if -F "#{@pane-is-vim}" 'send-keys C-j' 'select-pane -D'
        bind-key -n C-k if -F "#{@pane-is-vim}" 'send-keys C-k' 'select-pane -U'
        bind-key -n C-l if -F "#{@pane-is-vim}" 'send-keys C-l' 'select-pane -R'

        bind C-l send-keys 'C-l'

        unbind C-b
        unbind '"'
        unbind %
        unbind C-z

        unbind o
        bind-key o run-shell open-last-url
        unbind g
        bind-key g split-window -h -c "#{pane_current_path}"
        unbind h
        bind-key h split-window -c "#{pane_current_path}"
        unbind r
        bind-key r source ~/.config/tmux/tmux.conf
        unbind s
        bind-key s run-shell tmux-sesh-open

        # -----------------------------------------------------------------------------
        # UI (Gruvbox dark)
        # -----------------------------------------------------------------------------

        set-window-option -g mode-style "fg=#${fg},bg=#${bg}"

        set-option -g status-left "#[bg=#${bg},fg=#${fg}] #S #[fg=#${bg},bg=#${bg-dark},nobold,noitalics,nounderscore]"
        set-option -g status-right "#[fg=#${fg-dim},nobold,nounderscore,noitalics]#[bg=#${fg-dim},fg=#${fg}] #(tomato -t)  %Y-%m-%d  %H:%M #[fg=#${bg},bg=#${fg-dim},nobold,noitalics,nounderscore]#[bg=#${bg},fg=#${fg}] #h"
      '';
    };
  };
}
