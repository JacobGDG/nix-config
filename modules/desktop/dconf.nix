{
  flake.modules.homeManager.dconf = {
    config,
    lib,
    pkgs,
    ...
  }: let
    c = config.colorScheme.paletteRgb;
    colorGroup = bg: alt: fg: {
      BackgroundNormal = bg;
      BackgroundAlternate = alt;
      ForegroundNormal = fg;
      ForegroundInactive = c.base04;
      ForegroundActive = c.base09;
      ForegroundLink = c.base0D;
      ForegroundVisited = c.base0E;
      ForegroundNegative = c.base08;
      ForegroundNeutral = c.base0A;
      ForegroundPositive = c.base0B;
      DecorationFocus = c.base0D;
      DecorationHover = c.base0D;
    };
    kdeColors = {
      "Colors:Window" = colorGroup c.base00 c.base01 c.base05;
      "Colors:View" = colorGroup c.base00 c.base01 c.base05;
      "Colors:Button" = colorGroup c.base01 c.base02 c.base05;
      "Colors:Selection" = colorGroup c.base0D c.base0C c.base00;
      "Colors:Tooltip" = colorGroup c.base01 c.base02 c.base05;
      "Colors:Header" = colorGroup c.base01 c.base02 c.base05;
      "Colors:Complementary" = colorGroup c.base00 c.base01 c.base05;
    };
  in {
    home.packages = with pkgs; [
      adw-gtk3
      gruvbox-plus-icons
    ];

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        gtk-theme = "adw-gtk3-dark";
        icon-theme = "Gruvbox-Plus-Dark";
      };
    };

    # Qt apps (dolphin) only read kdeglobals through the KDE platform theme
    qt = {
      enable = true;
      platformTheme.name = "kde";
      # the platform theme takes its palette from the named .colors file; KDE widgets read kdeglobals
      kde.settings.kdeglobals =
        {
          Icons.Theme = "Gruvbox-Plus-Dark";
          General.ColorScheme = "Gruvbox";
        }
        // kdeColors;
    };

    xdg.dataFile."color-schemes/Gruvbox.colors".text = lib.generators.toINI {} (kdeColors
      // {
        General = {
          Name = "Gruvbox";
          ColorScheme = "Gruvbox";
        };
      });
  };
}
