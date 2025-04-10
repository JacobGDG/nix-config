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
    ] ++ lib.optionals (builtins.elem "wireguard" platformConfig.workloads) [
      outputs.homeManagerModules.wireguard
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

    # Sometimes (rarely), just use brew, it works
    sessionPath = lib.optionals pkgs.stdenv.isDarwin [
      "/opt/homebrew/bin/brew"
    ];

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
    ] ++ lib.optionals (platformConfig.isNixOS) [
      devenv
      blender
      vlc
    ] ++ lib.optionals (platformConfig.isDarwin) [
    ] ++ lib.optionals (builtins.elem "terraform" platformConfig.workloads) [
      opentofu
      tflint
      checkov
      terraform
    ] ++ lib.optionals (builtins.elem "docker" platformConfig.workloads) [
      # docker is not trivial to install, this is bare minimum to get what I need at work done for now
      docker-credential-helpers
    ] ++ lib.optionals (builtins.elem "raspberry-pi" platformConfig.workloads) [
        rpi-imager
    ] ++ lib.optionals (builtins.elem "libroffice" platformConfig.workloads) [
      libreoffice-qt
      hunspell
      hunspellDicts.en_GB-large
    ] ++ lib.optionals (builtins.elem "genealogy" platformConfig.workloads) [
      gramps
      graphviz
    ];
  };
  fonts.fontconfig.enable = true;
}
