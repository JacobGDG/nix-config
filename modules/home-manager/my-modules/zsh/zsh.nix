{
  config,
  lib,
  mylib,
  pkgs,
  ...
}: let
  cfg = config.myModules.zsh;
in {
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
      shellAliases =
        {
          cd = "z";
          la = "ls -lAh";
          vim = "nvim";
          zadd = "ls -d */ | xargs -I {} zoxide add {}";
          gwt = "git worktree";
        }
        // cfg.extraAliases;

      initContent = ''
        source ~/.config/zsh/.p10k.zsh

        bindkey '^R' history-incremental-search-backward
        bindkey '^H' backward-delete-char
        bindkey '^?' backward-delete-char

        if [ -z "$TMUX" ] && [ "$TERM" = "xterm-kitty" ]; then
          tmux attach || exec tmux new-session -t home && exit;
        fi

        export PATH="${config.home.profileDirectory}/bin:$PATH"
      '';

      plugins = [
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
