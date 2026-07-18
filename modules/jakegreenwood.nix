{
  nixpkgs.allowedUnfreePackages = ["dbeaver-bin" "spotify"];

  flake.modules.homeManager.jakegreenwood = {
    pkgs,
    inputs,
    ...
  }: {
    imports = with inputs.self.modules.homeManager; [
      aiAgents
      bark
      devops
      direnv
      git
      neovim
      scripts
      sesh
      starship
      terminal
      tmux
      tmuxifier
      zsh
    ];

    home.packages = with pkgs; [
      # (python311.withPackages (ps: [ps.pip]))
      btop
      dbeaver-bin
      docker-credential-helpers
      fzf
      gh
      jira-cli-go
      jq
      just
      pre-commit
      ripsecrets
      spotify
      tealdeer
      ttyper
      watch
      yq-go
    ];

    programs = {
      ripgrep.enable = true;
    };
  };
}
