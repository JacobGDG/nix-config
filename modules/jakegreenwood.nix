{
  nixpkgs.allowedUnfreePackages = ["dbeaver-bin" "spotify"];

  flake.modules.homeManager.jakegreenwood = {
    pkgs,
    inputs,
    ...
  }: {
    imports = with inputs.self.modules.homeManager; [
      aiAgents
      devops
      git
      neovim
      scripts
      direnv
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
      jira-cli-go
      jq
      ripsecrets
      spotify
      ttyper
      yq-go
      just
      pre-commit
      tealdeer
      watch
      fzf
      gh
    ];

    programs = {
      ripgrep.enable = true;
    };
  };
}
