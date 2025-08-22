{
  pkgs,
  config,
  ...
}: {
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    mouse = true;
    clock24 = true;
    baseIndex = 1;
    prefix = "C-a";
    escapeTime = 10;
    historyLimit = 50000;

    # https://github.com/NixOS/nixpkgs/blob/master/pkgs/misc/tmux-plugins/default.nix
    plugins = with pkgs; [
      tmuxPlugins.gruvbox
      tmuxPlugins.extrakto
    ];

    extraConfig = ''
      set -gu default-command
      set -g default-shell "$SHELL"

      # Undercurl
      set -g default-terminal "tmux-256color"

      set -sg escape-time 10
      set -g focus-events on

      # Remove Vim mode delays
      set -g focus-events on

      set -g detach-on-destroy off  # don't exit from tmux when closing a session

      set -g set-titles on
      set -g set-titles-string '#S'

      # -----------------------------------------------------------------------------
      # Key bindings
      # -----------------------------------------------------------------------------

      # Smart pane switching with awareness of Neovim splits.
      bind-key -n C-h if -F "#{@pane-is-vim}" 'send-keys C-h'  'select-pane -L'
      bind-key -n C-j if -F "#{@pane-is-vim}" 'send-keys C-j'  'select-pane -D'
      bind-key -n C-k if -F "#{@pane-is-vim}" 'send-keys C-k'  'select-pane -U'
      bind-key -n C-l if -F "#{@pane-is-vim}" 'send-keys C-l'  'select-pane -R'

      # after ^, reenable crtl-l (clear console) now just needs <prefix> beforehand
      bind C-l send-keys 'C-l'

      # Unbind default keys
      unbind C-b
      unbind '"'
      unbind %
      # auto launch tmux creates a blank screen here. often pressed with split zoom
      unbind C-z

      # vertical splits with g
      unbind g
      bind-key g split-window -h -c "#{pane_current_path}"

      # horizontal splits with h
      unbind h
      bind-key h split-window -c "#{pane_current_path}"

      unbind o
      bind-key o run-shell "open-last-url"

      # source tmus
      bind-key r source ~/.config/tmux/tmux.conf

      unbind s
      bind-key "s" run-shell "sesh connect \"$(
        sesh list --icons | fzf-tmux -p 55%,60% \
        --no-sort --ansi --border-label ' sesh ' --prompt '⚡  ' \
        --header '  ^a all ^t tmux ^g configs ^x zoxide ^d tmux kill ^f find' \
        --bind 'tab:down,btab:up' \
        --bind 'ctrl-a:change-prompt(⚡  )+reload(sesh list --icons)' \
        --bind 'ctrl-t:change-prompt(🪟  )+reload(sesh list -t --icons)' \
        --bind 'ctrl-g:change-prompt(⚙️  )+reload(sesh list -c --icons)' \
        --bind 'ctrl-x:change-prompt(📁  )+reload(sesh list -z --icons)' \
        --bind 'ctrl-f:change-prompt(🔎  )+reload(fd -H -d 2 -t d -E .Trash . ~)' \
        --bind 'ctrl-d:execute(tmux kill-session -t {2..})+change-prompt(⚡  )+reload(sesh list --icons)' \
        --preview 'sesh preview {}' \
      )\""

      # fingers
      unbind Space
      bind-key Space run-shell "${pkgs.tmuxPlugins.extrakto}/share/tmux-plugins/extrakto/scripts/open.sh \"#{pane_id}\""

      # -----------------------------------------------------------------------------
      # UI
      # -----------------------------------------------------------------------------

      set-option -g status-right "#[bg=colour237,fg=colour239 nobold, nounderscore, noitalics]#[bg=colour239,fg=colour246] #(tomato -t)  %Y-%m-%d  %H:%M #[bg=colour239,fg=colour248,nobold,noitalics,nounderscore]#[bg=colour248,fg=colour237] #h"

      # colourscheme
      set-window-option -g mode-style "fg=#${config.colorScheme.palette.base05},bg=#${config.colorScheme.palette.base02}"
    '';
  };
}
