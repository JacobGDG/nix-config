{...}: {
  jg.cava.homeManager = {config, ...}: {
    programs.cava = {
      enable = true;
      settings = {
        general.mode = "normal";
        general.sensitivity = 70;
        color = {
          gradient = 1;
          gradient_count = 4;
          gradient_color_1 = "'#${config.theme.palette.base0D}'";
          gradient_color_2 = "'#${config.theme.palette.base0C}'";
          gradient_color_3 = "'#${config.theme.palette.base0B}'";
          gradient_color_4 = "'#${config.theme.palette.base0A}'";
        };
      };
    };
  };
}
