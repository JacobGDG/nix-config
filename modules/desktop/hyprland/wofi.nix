{jg, ...}: {
  jg.hyprland.includes = [jg.wofi];

  jg.wofi.homeManager = {
    config,
    pkgs,
    ...
  }: let
    p = config.theme.palette;
    cheatsheet = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/groovykiwi/rofi-nerdfont/2e30cd34e1c0e3aaa755a5a88dd5da9476403a5d/nerd-font-cheatsheet.txt";
      hash = "sha256-vjgRbfcwlkCtcJxS6y247RZe9WpMESxYrngpFveuUM0=";
    };
    wofiDevicons = pkgs.writeShellApplication {
      name = "wofi-devicons";
      runtimeInputs = with pkgs; [wofi wtype wl-clipboard];
      text = ''
        set -euo pipefail
        DEVICON="$(wofi -p "devicon" --show dmenu -i < ${cheatsheet} | awk '{print $1}')"
        wtype "$DEVICON"; wl-copy "$DEVICON"
      '';
    };
    deviconsIcon = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/ryanoasis/nerd-fonts/a44afb8aebf2eeef8798e1deb1a9eeb207ec3a3b/assets/img/nerd-fonts-logo.svg";
      hash = "sha256-yYQsRhSvXxW5CW/EgmOKip/w1ovo0A9DeXrZq9GlO7g=";
    };
    wofiEmojies = pkgs.writeShellApplication {
      name = "wofi-emojies";
      runtimeInputs = with pkgs; [wofi wtype wl-clipboard];
      text = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/Zeioth/wofi-emoji/7fe4c6316cb69ff7d8cf1b98ece4695d42785e2a/wofi-emoji";
        hash = "sha256-zv3hDGSthPvajwFtb75JjorS3GCXaxeKg4SZbP57LAU=";
        executable = true;
      };
    };
    emojiesIcon = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/googlefonts/noto-emoji/8998f5dd683424a73e2314a8c1f1e359c19e8742/svg/emoji_u1f31d.svg";
      hash = "sha256-iOW0LsZgPQMo7LlcElVtN4/Zwt0uCEfI7I3TE3Y3Qdw=";
    };
  in {
    home.packages = [pkgs.xdg-terminal-exec];

    programs.wofi = {
      enable = true;

      settings = {
        width = 650;
        key_up = "Ctrl-k";
        key_down = "Ctrl-j";
        key_expand = "Tab";
        term = "${pkgs.kitty}/bin/kitty";
        allow_markup = true;
        show = "drun";
        prompt = "Apps";
        normal_window = true;
        layer = "top";
        height = "325px";
        orientation = "vertical";
        halign = "fill";
        line_wrap = "off";
        dynamic_lines = false;
        allow_images = true;
        image_size = 24;
        exec_search = false;
        hide_search = false;
        parse_search = false;
        insensitive = true;
        hide_scroll = true;
        no_actions = false;
        sort_order = "default";
        gtk_dark = true;
        filter_rate = 100;
        key_exit = "Escape";
        close_on_focus_loss = true;
      };

      style = ''
        * {
          font-family: JetBrainsMono;
          font-size: 12px;
          border-radius: 5px;
        }

        #window {
           background-color: #${p.base00};
           color: #${p.base05};
           border-radius: 5px;
         }
         #outer-box {
           padding: 20px;
         }

         #input {
           background-color: #${p.base01};
           border: 0px solid #${p.base0D};
           color: #${p.base05};
           padding: 8px 12px;
         }

         #scroll {
           margin-top: 20px;
         }

         #inner-box {}

         #img {
           padding-right: 8px;
         }

         #text {
           color: #${p.base05};
         }

         #text:selected {
           color: #${p.base05};
         }

         #entry {
           padding: 6px;
         }

         #entry:selected {
           background-color: #${p.base0D};
           color: #${p.base05};
         }

         #unselected {}

         #selected {}

         #input,
         #entry:selected {
           border-radius: 5px;
         }
      '';
    };

    xdg.desktopEntries = {
      devicons = {
        name = "Devicons";
        genericName = "Devicons";
        comment = "Devicons";
        exec = "${wofiDevicons}/bin/wofi-devicons";
        icon = deviconsIcon;
        terminal = false;
      };
      emojies = {
        name = "Emojies";
        genericName = "Emojies";
        comment = "Emojies";
        icon = emojiesIcon;
        exec = "${wofiEmojies}/bin/wofi-emojies";
        terminal = false;
      };
    };
  };
}
