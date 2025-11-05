{pkgs, ...}: {
  programs.home-manager.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
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
