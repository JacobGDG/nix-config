{
  nixpkgs.allowedUnfreePackages = ["obsidian" "discord"];

  flake.modules.homeManager.jake = {
    pkgs,
    inputs,
    ...
  }: {
    imports = with inputs.self.modules.homeManager; [
      aiAgents
      bark
      cava
      dconf
      devops
      direnv
      firefox
      git
      libreoffice
      mpv
      neovim
      scripts
      sesh
      spotifyPlayer
      starship
      thunderbird
      tmux
      tmuxifier
      udiskie
      zsh
    ];

    home = {
      username = "jake";
      homeDirectory = "/home/jake";

      packages = with pkgs; [
        blender
        bottom
        discord
        fzf
        gh
        htop
        jq
        just
        mumble
        obsidian
        pre-commit
        prismlauncher
        ripsecrets
        rpi-imager
        tealdeer
        tomato-c
        tree
        ttyper
        watch
        yq
      ];
    };

    programs = {
      ripgrep.enable = true;
    };
  };
}
