{pkgs, ...}: {
  programs.home-manager.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    stdlib = ''
      : ''${XDG_CACHE_HOME:=$HOME/.cache}
      declare -A direnv_layout_dirs
      direnv_layout_dir() {
        echo "''${direnv_layout_dirs[$PWD]:=$(
          echo -n "$XDG_CACHE_HOME"/direnv/layouts/
          echo -n "$PWD" | sha1sum | cut -d ' ' -f 1
        )}"
      }
    '';
  };

  programs.ripgrep = {
    enable = true;
    arguments = ["--smart-case"];
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  home.packages = with pkgs; [
    bottom
    dig
    fzf
    gh
    git
    htop
    just
    nerd-fonts.jetbrains-mono
    obsidian
    pre-commit
    tealdeer
    tomato-c
    tree
    watch
    xclip
  ];
}
