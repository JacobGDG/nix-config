{
  pkgs,
  mylib,
  ...
}: {
  imports = map mylib.homeManagerModules [
    "alacritty.nix"
    "btop.nix"
    "cava.nix"
    "git.nix"
    "neovim.nix"
    "ripgrep.nix"
    "tmux.nix"
    "yazi.nix"
    "zoxide.nix"
    "zsh.nix"
    "kubernetes.nix"
  ];

  nixpkgs.config.allowUnfree = true;
  systemd.user.startServices = "sd-switch";

  programs.home-manager.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  home = {
    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "24.05";

    packages = with pkgs; [
      (pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];})
      dig
      fzf
      gh
      git
      htop
      just
      obsidian
      pre-commit
      tldr
      tomato-c
      tree
      watch
      xclip
    ];
  };
  fonts.fontconfig.enable = true;
}
