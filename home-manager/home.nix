{
  inputs,
  outputs,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    outputs.homeManagerModules.alacritty
    outputs.homeManagerModules.zsh
    outputs.homeManagerModules.git
    outputs.homeManagerModules.tmux
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  programs = {
    home-manager.enable = true;

    neovim = {
      enable = true;
      vimAlias = true;
      viAlias = true;

      defaultEditor = true;
    };
  };

  home = {
    packages = with pkgs; [
      htop
      just
      tldr
      gh
      git
      (nerdfonts.override { fonts = ["JetBrainsMono" "Inconsolata"]; })
    ];

    file = {
      ".config/nvim" = {
        source = ../config/nvim;
	recursive = true;
      };
    };

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "24.05";
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
