{
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    mouse = true;
    clock24 = true;
    baseIndex = 1;
    prefix = "C-a";
    escapeTime = 10;
    historyLimit = 50000;
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
      set -g status-left-length 90
      set -g status-right-length 90
      set -g status-justify centre
  
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
    '';
  };
}
