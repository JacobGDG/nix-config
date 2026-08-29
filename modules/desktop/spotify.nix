{
  nixpkgs.allowedUnfreePackages = ["spotify"];

  persist = {
    users = {
      directories = [
        ".config/spotify"
        ".cache/spotify"
      ];
    };
  };

  flake.modules.homeManager.spotifyPlayer = {pkgs, ...}: {
    home.packages = [
      pkgs.spotify
    ];

    programs.spotify-player = {
      enable = true;
    };
  };
}
