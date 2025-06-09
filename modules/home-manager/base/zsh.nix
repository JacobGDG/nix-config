{
  pkgs,
  lib,
  ...
}: {
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    history = {
      size = 10000;
    };
    shellAliases =
      {
        "cd" = "z";
        "la" = "ls -lAh";
        "vim" = "nvim";
        "zadd" = "ls -d */ | xargs -I {} zoxide add {}";
      }
      // lib.mkIf pkgs.stdenv.isLinux {
        "pbcopy" = "xclip -selection clipboard"; # darwin has pbcopy
      };

    initContent = let
      zshConfigEarlyInit = lib.mkBefore "
                    if [[ -r \"\${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-\${(%):-%n}.zsh\" ]]; then
                      source \"\${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-\${(%):-%n}.zsh\"
                    fi
                  ";
      zshConfig = lib.mkOrder 1000 "
                    source ~/.config/zsh/.p10k.zsh

                    bindkey '^R' history-incremental-search-backward

                    setopt appendhistory
                    setopt sharehistory
                    setopt hist_ignore_space
                    setopt hist_ignore_all_dups
                    setopt hist_save_no_dups
                    setopt hist_ignore_dups
                    setopt hist_find_no_dups

                    if [ -z \"$TMUX\" ] && [ \"$TERM\" = \"xterm-kitty\" ]; then
                      tmux attach || exec tmux new-session && exit;
                    fi
                  ";
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
}
