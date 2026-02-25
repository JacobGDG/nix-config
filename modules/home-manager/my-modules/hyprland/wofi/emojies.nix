{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.myModules.hyprland.wofi;
  wofiEmojies = pkgs.writeShellApplication {
    name = "wofi-emojies";

    runtimeInputs = with pkgs; [
      wofi
      wtype
      wl-clipboard
    ];

    text = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/Zeioth/wofi-emoji/7fe4c6316cb69ff7d8cf1b98ece4695d42785e2a/wofi-emoji";
      hash = "sha256-zv3hDGSthPvajwFtb75JjorS3GCXaxeKg4SZbP57LAU=";
      executable = true;
    };
  };

  icon = pkgs.fetchurl {
    url = "https://slackmojis.com/emojis/38331-smiley/download";
    hash = "sha256-mcB4psADEyxMOsiR7cXKDZPNsGi9DpnGZ4QvsajKp90=";
  };
in {
  config = lib.mkIf cfg.enable {
    xdg.desktopEntries = {
      emojies = {
        name = "Emojies";
        genericName = "Emojies";
        comment = "Emojies";
        icon = icon;
        exec = "${wofiEmojies}/bin/wofi-emojies";
        terminal = false;
      };
    };
  };
}
