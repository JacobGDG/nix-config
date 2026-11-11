{
  persist = {
    users = {
      directories = [
        ".local/share/direnv"
      ];
    };
  };

  flake.modules.homeManager.direnv = {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
