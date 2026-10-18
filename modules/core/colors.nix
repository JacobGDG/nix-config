{
  flake.modules.homeManager.core = {
    config,
    lib,
    ...
  }: {
    options.colorScheme = {
      palette = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = {
          # gruvbox-dark-medium
          base00 = "282828";
          base01 = "3c3836";
          base02 = "504945";
          base03 = "665c54";
          base04 = "bdae93";
          base05 = "d5c4a1";
          base06 = "ebdbb2";
          base07 = "fbf1c7";
          base08 = "fb4934";
          base09 = "fe8019";
          base0A = "fabd2f";
          base0B = "b8bb26";
          base0C = "8ec07c";
          base0D = "83a598";
          base0E = "d3869b";
          base0F = "d65d0e";
        };
        description = "Base16 colour palette. Defaults to gruvbox-dark-medium.";
      };

      paletteRgb = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        readOnly = true;
        default = lib.mapAttrs (_: hex:
          lib.concatMapStringsSep "," (i: toString (lib.fromHexString (builtins.substring i 2 hex))) [0 2 4])
        config.colorScheme.palette;
        defaultText = lib.literalMD "`palette` as `\"r,g,b\"` strings";
        description = "The palette as comma-separated decimal RGB, e.g. for kdeglobals.";
      };
    };
  };
}
