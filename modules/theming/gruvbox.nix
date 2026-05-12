{
  jg,
  lib,
  ...
}: {
  jg.gruvbox.homeManager = {
    options.theme.palette = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      description = "Active colour palette (base16)";
    };

    config.theme.palette = {
      base00 = "fffff";
      base01 = "fffff";
      base02 = "fffff";
      base03 = "fffff";
      base04 = "fffff";
      base05 = "fffff";
      base06 = "fffff";
      base07 = "fffff";
      base08 = "fffff";
      base09 = "fffff";
      base0A = "fffff";
      base0B = "fffff";
      base0C = "fffff";
      base0D = "fffff";
      base0E = "fffff";
      base0F = "fffff";
    };
  };
}
