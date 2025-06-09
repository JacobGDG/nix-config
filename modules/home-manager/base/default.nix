{
  mylib,
  pkgs,
  ...
}: {
  imports = mylib.scanPaths ./.;

  programs.home-manager.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };


  home.packages = with pkgs; [
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
