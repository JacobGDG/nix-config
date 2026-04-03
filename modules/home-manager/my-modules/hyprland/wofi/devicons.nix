{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.myModules.hyprland.wofi;
  cheatsheet = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/groovykiwi/rofi-nerdfont/2e30cd34e1c0e3aaa755a5a88dd5da9476403a5d/nerd-font-cheatsheet.txt";
    hash = "sha256-vjgRbfcwlkCtcJxS6y247RZe9WpMESxYrngpFveuUM0=";
  };
  wofiDevicons = pkgs.writeShellApplication {
    name = "wofi-devicons";

    runtimeInputs = with pkgs; [
      wofi
      wtype
      wl-clipboard
    ];

    text = ''
      set -euo pipefail

      DEVICON="$(wofi -p "devicon" --show dmenu -i < ${cheatsheet} | awk '{print $1}')"

      wtype "$DEVICON"; wl-copy "$DEVICON"
    '';
  };
  icon = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/ryanoasis/nerd-fonts/a44afb8aebf2eeef8798e1deb1a9eeb207ec3a3b/assets/img/nerd-fonts-logo.svg";
    hash = "sha256-yYQsRhSvXxW5CW/EgmOKip/w1ovo0A9DeXrZq9GlO7g=";
  };
in {
  config = lib.mkIf cfg.enable {
    xdg.desktopEntries = {
      devicons = {
        name = "Devicons";
        genericName = "Devicons";
        comment = "Devicons";
        exec = "${wofiDevicons}/bin/wofi-devicons";
        icon = icon;
        terminal = false;
      };
    };
  };
}
