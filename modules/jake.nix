{
  flake.modules.homeManager = {
    jake = {
      home = {
        username = "jake";
        homeDirectory = "/home/jake";
      };
    };
    "jake@erebor" = {};
  };
}
