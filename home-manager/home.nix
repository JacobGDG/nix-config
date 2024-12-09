{ inputs, outputs, pkgs, platformConfig, ... }:
{
  # You can import other home-manager modules here
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    
    outputs.homeManagerModules.alacritty
    outputs.homeManagerModules.btop
    outputs.homeManagerModules.git
    outputs.homeManagerModules.neovim
    outputs.homeManagerModules.ripgrep
    outputs.homeManagerModules.tmux
    outputs.homeManagerModules.zoxide
    outputs.homeManagerModules.zsh
  ];

  nixpkgs.config.allowUnfree = platformConfig.allowUnfree;
  systemd.user.startServices = "sd-switch";
  programs.home-manager.enable = true;

  home = {
    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "24.05";

    homeDirectory = platformConfig.homeDirectory;
    username = platformConfig.username;

    packages = with pkgs; [
      (nerdfonts.override { fonts = ["JetBrainsMono"]; })
      fzf
      gh
      git
      htop
      just
      tldr
      yazi
    ];
  };
}
