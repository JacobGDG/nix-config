{
  nixpkgs.allowedUnfreePackages = ["steam" "steam-unwrapped"];

  flake.modules.nixos.steam = {...}: {
    programs.steam = {
      enable = true;
    };

    programs.gamescope = {
      enable = true;
    };
  };
}
