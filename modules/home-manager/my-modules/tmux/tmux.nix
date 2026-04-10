{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.myModules.tmux;

  other_pane = pkgs.writeScriptBin "tmux-other-pane" (builtins.readFile ./scripts/tmux-other-pane.sh);

  mkBinding = key: value: ''
    unbind ${key}
    bind-key ${key} ${value}
  '';
in {
  config = lib.mkIf cfg.enable {
    home.packages = [
      other_pane
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
      focusEvents = true;
      terminal = "tmux-256color";
      shell = cfg.shell;

      # https://github.com/NixOS/nixpkgs/blob/master/pkgs/misc/tmux-plugins/default.nix
      plugins = with pkgs; [
        tmuxPlugins.gruvbox
      ];

      extraConfig = ''
        set -gu default-command

        # Undercurl

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

        ${lib.concatStrings (builtins.attrValues (builtins.mapAttrs mkBinding cfg.bindings))}

        # -----------------------------------------------------------------------------
        # UI
        # -----------------------------------------------------------------------------

        set-option -g status-left "#[bg=#${config.colorScheme.palette.base02},fg=#${config.colorScheme.palette.base05}] #S #[fg=#${config.colorScheme.palette.base02},bg=#${config.colorScheme.palette.base01},nobold,noitalics,nounderscore]"

        # set-option -g window-status-current-format

        set-option -g status-right "#[fg=#${config.colorScheme.palette.base03}, nobold, nounderscore, noitalics]#[bg=#${config.colorScheme.palette.base03},fg=#${config.colorScheme.palette.base05}] #(tomato -t)  %Y-%m-%d  %H:%M #[fg=#${config.colorScheme.palette.base02},bg=#${config.colorScheme.palette.base03},nobold,noitalics,nounderscore]#[bg=#${config.colorScheme.palette.base02},fg=#${config.colorScheme.palette.base05}] #h"

        # colourscheme
        set-window-option -g mode-style "fg=#${config.colorScheme.palette.base05},bg=#${config.colorScheme.palette.base02}"
      '';
    };
  };
}
