{den, ...}: {
  jg.discord = {
    includes = [(den.provides.unfree ["discord"])];
    homeManager = {pkgs, ...}: {
      home.packages = [pkgs.discord];
    };
  };
}
