{lib, ...}: {
  jg.gruvbox.homeManager = {
    options.theme.palette = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      description = "Active colour palette (base16)";
    };

    # base16-gruvbox-dark-medium
    config.theme.palette = {
      base00 = "282828"; # background
      base01 = "3c3836"; # dark bg 1
      base02 = "504945"; # dark bg 2
      base03 = "665c54"; # dark bg 3 / comments
      base04 = "bdae93"; # light bg 3
      base05 = "d5c4a1"; # foreground 1
      base06 = "ebdbb2"; # foreground 0
      base07 = "fbf1c7"; # light bg 0
      base08 = "fb4934"; # red
      base09 = "fe8019"; # orange
      base0A = "fabd2f"; # yellow
      base0B = "b8bb26"; # green
      base0C = "8ec07c"; # aqua/cyan
      base0D = "83a598"; # blue
      base0E = "d3869b"; # purple
      base0F = "d65d0e"; # brown/dark orange
    };
  };
}
