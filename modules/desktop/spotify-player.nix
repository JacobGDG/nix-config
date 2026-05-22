{
  flake.modules.homeManager.spotifyPlayer = {...}: {
    programs.spotify-player = {
      enable = true;
    };
  };
}
