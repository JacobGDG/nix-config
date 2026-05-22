{
  flake.modules.homeManager."jake@erebor" = {};
  nixpkgs.allowedUnfreePackages = ["obsidian"];

  flake.modules.homeManager.jake = {
    pkgs,
    inputs,
    ...
  }: {
    imports = with inputs.self.modules.homeManager; [
      zsh
      starship
      tmux
      sesh
      tmuxifier
      git
      neovim
      dconf
      udiskie
      thunderbird
      libreoffice
    ];

    home = {
      username = "jake";
      homeDirectory = "/home/jake";

      packages = with pkgs; [
        fzf
        gh
        just
        obsidian
        pre-commit
        tealdeer
        bottom
        htop
        tree
        watch
        jq
        yq
        ripsecrets
        ttyper
        tomato-c
      ];
    };

    wayland.windowManager.hyprland.settings = {
      input = {
        kb_layout = "gb";
        kb_options = "ctrl:nocaps";
      };
    };

    programs = {
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      ripgrep.enable = true;

      zoxide = {
        enable = true;
        enableZshIntegration = true;
      };
    };
  };
}
