{
  nixpkgs.allowedUnfreePackages = ["spotify"];

  flake.modules.homeManager.spotifyPlayer = {pkgs, ...}: {
    home.packages = [
      pkgs.spotify
    ];

    programs.spotify-player = {
      enable = true;
    };
  };
}
