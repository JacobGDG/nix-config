{
  flake.modules.homeManager.tmux = {
    config,
    lib,
    pkgs,
    ...
  }: let
    tmux-other-pane = pkgs.writeScriptBin "tmux-other-pane" ''
      #!/usr/bin/env bash
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
  in {
    home.packages = [tmux-other-pane];

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

        set-option -g status-left "#[bg=#${config.colorScheme.palette.base02},fg=#${config.colorScheme.palette.base05}] #S #[fg=#${config.colorScheme.palette.base02},bg=#${config.colorScheme.palette.base01},nobold,noitalics,nounderscore]"
        set-option -g status-right "#[fg=#${config.colorScheme.palette.base03}, nobold, nounderscore, noitalics]#[bg=#${config.colorScheme.palette.base03},fg=#${config.colorScheme.palette.base05}] %Y-%m-%d  %H:%M #[fg=#${config.colorScheme.palette.base02},bg=#${config.colorScheme.palette.base03},nobold,noitalics,nounderscore]#[bg=#${config.colorScheme.palette.base02},fg=#${config.colorScheme.palette.base05}] #h"
        set-window-option -g mode-style "fg=#${config.colorScheme.palette.base05},bg=#${config.colorScheme.palette.base02}"
      '';
    };
  };
}
