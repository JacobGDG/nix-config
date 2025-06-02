{
  pkgs,
  mylib,
  inputs,
  ...
}: {
  imports =
    [
      inputs.nix-colors.homeManagerModules.default
    ]
    ++ map mylib.homeManagerModules [
      "cava.nix"
      "git.nix"
      "kitty.nix"
      "kubernetes.nix"
      "neovim.nix"
      "ripgrep.nix"
      "tmux.nix"
      "yazi.nix"
      "zoxide.nix"
      "zsh.nix"
      "scripts"
    ];

  colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-medium;

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
      nerd-fonts.jetbrains-mono
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
