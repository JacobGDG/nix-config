{
  nixpkgs.allowedUnfreePackages = ["obsidian" "discord"];

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
      bark
      thunderbird
      spotifyPlayer
      cava
      devops
      aiAgents
      firefox
      direnv
      mpv
      libreoffice
      scripts
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
        blender
        discord
        mumble
        prismlauncher
        rpi-imager
      ];
    };

    wayland.windowManager.hyprland.settings = {
      input = {
        kb_layout = "gb";
        kb_options = "ctrl:nocaps";
        repeat_delay = 200;
        repeat_rate = 40;
      };
    };

    programs = {
      ripgrep.enable = true;
    };
  };
}
