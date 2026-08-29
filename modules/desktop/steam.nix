{
  nixpkgs.allowedUnfreePackages = ["steam" "steam-unwrapped"];

  persist = {
    users = {
      directories = [
        ".steam"
        ".local/share/Steam"
      ];
    };
  };

  flake.modules.nixos.steam = {...}: {
    programs.steam = {
      enable = true;
    };

    programs.gamescope = {
      enable = true;
    };
  };
}
