{ pkgs, lib, ... }:
let
  tmux-powerline = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "powerline";
    version = "3.0.0";
    src = pkgs.fetchFromGitHub {
      owner = "erikw";
      repo = "tmux-powerline";
      rev = "2480e5531e0027e49a90eaf540f973e624443937";
      hash = "sha256-25uG7OI8OHkdZ3GrTxG1ETNeDtW1K+sHu2DfJtVHVbk=";
    };
    rtpFilePath = "main.tmux";
    meta = {
      homepage = "https://github.com/erikw/tmux-powerline";
      description = "Empowering your tmux (status bar) experience!";
      longDescription = "A tmux plugin giving you a hackable status bar consisting of dynamic & beautiful looking powerline segments, written purely in bash.";
      license = lib.licenses.bsd3;
      platforms = lib.platforms.unix;
      maintainers = with lib.maintainers; [ thomasjm ];
    };
  };
in {
  imports = [
    ./sesh.nix
    ./tmuxifier.nix
    ./zoxide.nix
  ];

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
      tmux-powerline
    ];

    extraConfig = ''
      #set -ag terminal-overrides ",xterm-256color:RGB"
      #set-option -sa terminal-features ',alacritty:RGB'
      #set-option -ga terminal-features ",alacritty:usstyle"
  
      # Undercurl
      set -g default-terminal "tmux-256color"
  
      set -sg escape-time 10
      set -g focus-events on
  
      # Remove Vim mode delays
      set -g focus-events on
      # set -g status-left-length 90
      # set -g status-right-length 90
      # set -g status-justify centre

      set -g detach-on-destroy off  # don't exit from tmux when closing a session

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
  
      # vertical splits with g
      unbind g
      bind-key g split-window -h -c "#{pane_current_path}"
      
      # horizontal splits with h
      unbind h
      bind-key h split-window -c "#{pane_current_path}"

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
      )\""
    '';
  };
}
