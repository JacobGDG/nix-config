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
    url = "https://raw.githubusercontent.com/googlefonts/noto-emoji/8998f5dd683424a73e2314a8c1f1e359c19e8742/svg/emoji_u1f31d.svg";
    hash = "sha256-iOW0LsZgPQMo7LlcElVtN4/Zwt0uCEfI7I3TE3Y3Qdw=";
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
