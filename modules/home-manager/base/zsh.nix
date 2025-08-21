{
  pkgs,
  lib,
  ...
}: {
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    defaultKeymap = "viins";
    dotDir = ".config/zsh";
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
        "cd" = "z";
        "la" = "ls -lAh";
        "vim" = "nvim";
        "zadd" = "ls -d */ | xargs -I {} zoxide add {}";
      }
      // lib.mkIf pkgs.stdenv.isLinux {
        "pbcopy" = "xclip -selection clipboard"; # darwin has pbcopy
      };

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
}
