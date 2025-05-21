{
  pkgs,
  config,
  ...
}: {
  home.packages = [
    (pkgs.writeShellApplication {
      name = "wofi-emoji";

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
    })
    pkgs.xdg-terminal-exec # Opening terminal apps from wofi
  ];

  xdg.desktopEntries = {
    emojies = {
      name = "Emoji";
      genericName = "Emoji";
      comment = "Emoji";
      icon = "👋";
      exec = "${pkgs.wofi-emoji}/bin/wofi-emoji";
      terminal = false;
    };
  };

  programs.wofi = {
    enable = true;

    # man 5 wofi -- for config file options
    # man wofi-keys -- for key options
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
    };

    style = ''
      * {
        font-family: JetBrainsMono;
        font-size: 12px;
        border-radius: 5px;
      }

      #window {
         background-color: #${config.colorScheme.palette.base00};
         color: #${config.colorScheme.palette.base05};
         border-radius: 5px;
       }
       #outer-box {
         padding: 20px;
       }

       #input {
         background-color: #${config.colorScheme.palette.base01};
         border: 0px solid #${config.colorScheme.palette.base0D};
         color: #${config.colorScheme.palette.base05};
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
         color: #${config.colorScheme.palette.base05};
       }

       #text:selected {
         color: #${config.colorScheme.palette.base05};
       }

       #entry {
         padding: 6px;
       }

       #entry:selected {
         background-color: #${config.colorScheme.palette.base0D};
         color: #${config.colorScheme.palette.base05};
       }

       #unselected {}

       #selected {}

       #input,
       #entry:selected {
         border-radius: 5px;
       }
    '';
  };
}
