{
  config,
  lib,
  mylib,
  pkgs,
  ...
}: let
  cfg = config.myModules.zsh;
in {
  options = {
    myModules.zsh = {
      enable = lib.mkEnableOption "zsh";
      extraAliases = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = {};
        description = "Extra shell aliases to add to zsh configuration.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      dotDir = ".config/zsh";
      defaultKeymap = "viins";
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      history = {
        append = true;
        extended = true;
        findNoDups = true;
        ignoreSpace = true;
        share = true;
        size = 10000;
      };
      shellAliases = {
        cd = "z";
        la = "ls -lAh";
        vim = "nvim";
        zadd = "ls -d */ | xargs -I {} zoxide add {}";
      } // cfg.extraAliases;

      initContent = let
        zshConfigEarlyInit = lib.mkBefore ''
          if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
            source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
          fi
        '';
        zshConfig = lib.mkOrder 1000 ''
          source ~/.config/zsh/.p10k.zsh

          bindkey '^R' history-incremental-search-backward
          bindkey '^H' backward-delete-char
          bindkey '^?' backward-delete-char

          if [ -z "$TMUX" ] && [ "$TERM" = "xterm-kitty" ]; then
            tmux attach || exec tmux new-session -t home && exit;
          fi

          export PATH="${config.home.profileDirectory}/bin:$PATH"
        '';
      in
        lib.mkMerge [zshConfigEarlyInit zshConfig];

      plugins = [
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
        {
          name = "fzf-tab";
          src = pkgs.fetchFromGitHub {
            owner = "Aloxaf";
            repo = "fzf-tab";
            rev = "01dad759c4466600b639b442ca24aebd5178e799";
            sha256 = "q26XVS/LcyZPRqDNwKKA9exgBByE0muyuNb0Bbar2lY=";
          };
        }
      ];
    };
  };
}
