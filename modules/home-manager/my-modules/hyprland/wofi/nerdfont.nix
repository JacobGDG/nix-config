{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.myModules.hyprland.wofi;
  icons = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/groovykiwi/rofi-nerdfont/2e30cd34e1c0e3aaa755a5a88dd5da9476403a5d/nerd-font-cheatsheet.txt";
    hash = "sha256-vjgRbfcwlkCtcJxS6y247RZe9WpMESxYrngpFveuUM0=";
  };
  nerdFontCheatsheetFile = pkgs.runCommand "nerd-font-cheatsheet.txt" {} ''
    cp ${icons} $out
  '';
  wofiDevicons = pkgs.writeShellApplication {
    name = "wofi-devicons";

    runtimeInputs = with pkgs; [
      wofi
      wtype
      wl-clipboard
    ];

    text = ''
      #!/usr/bin/env bash
      set -euo pipefail

      DEVICON="$(wofi -p "devicon" --show dmenu -i < ${nerdFontCheatsheetFile} | awk '{print $1}')"

      wtype "$DEVICON"; wl-copy "$DEVICON"
    '';
  };
in {
  config = lib.mkIf cfg.enable {
    xdg.desktopEntries = {
      devicons = {
        name = "Devicons";
        genericName = "Devicons";
        comment = "Devicons";
        exec = "${wofiDevicons}/bin/wofi-devicons";
        terminal = false;
      };
    };
  };
}
