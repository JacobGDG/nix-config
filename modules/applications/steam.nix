{den, ...}: {
  jg.steam = {
    includes = [(den.provides.unfree ["steam" "steam-unwrapped" "steam-run"])];
    nixos = {
      programs.steam.enable = true;
      programs.gamescope.enable = true;
    };
  };
}
