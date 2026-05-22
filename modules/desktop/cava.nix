{
  flake.modules.homeManager.cava = {...}: {
    programs.cava = {
      enable = true;

      settings = {
        general.mode = "normal";
        general.sensitivity = 70;
        colour = {
          forground = "#d79921";
        };
      };
    };
  };
}
