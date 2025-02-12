{
  inputs,
  outputs,
  pkgs,
  platformConfig,
  lib,
  ...
}: {
  # You can import other home-manager modules here
  imports =
    [
      outputs.homeManagerModules.alacritty
      outputs.homeManagerModules.btop
      outputs.homeManagerModules.cava
      outputs.homeManagerModules.git
      outputs.homeManagerModules.neovim
      outputs.homeManagerModules.ripgrep
      outputs.homeManagerModules.tmux
      outputs.homeManagerModules.yazi
      outputs.homeManagerModules.zoxide
      outputs.homeManagerModules.zsh
    ]
    ++ lib.optionals (platformConfig.isNixOS) [
      outputs.homeManagerModules.plasma
      outputs.homeManagerModules.thunderbird
      outputs.homeManagerModules.spotify-player
    ] ++ lib.optionals (builtins.elem "kubernetes" platformConfig.workloads) [
      outputs.homeManagerModules.kubernetes
    ];

  nixpkgs.config.allowUnfree = platformConfig.allowUnfree;
  systemd.user.startServices = "sd-switch";
  programs.home-manager.enable = true;

  home = {
    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "24.05";

    homeDirectory = platformConfig.homeDirectory;
    username = platformConfig.username;

    sessionPath = [
      "/opt/homebrew/bin/brew"
    ];

    packages = with pkgs; [
      (pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];})
      fzf
      gh
      git
      htop
      just
      tldr
      tomato-c
      watch
      xclip
      dig
    ] ++ lib.optionals (platformConfig.isNixOS) [
      devenv
      wireguard-tools
    ] ++ lib.optionals (platformConfig.isDarwin) [
    ] ++ lib.optionals (builtins.elem "terraform" platformConfig.workloads) [
      opentofu
      tflint
      checkov
      terraform
    ] ++ lib.optionals (builtins.elem "docker" platformConfig.workloads) [
      # docker is not trivial to install, this is bare minimum to get what I need at work done for now
      docker-credential-helpers
    ] ++ lib.optionals (builtins.elem "libroffice" platformConfig.workloads) [
      libreoffice-qt
      hunspell
      hunspellDicts.en_GB-large
    ];
  };
  fonts.fontconfig.enable = true;
}
