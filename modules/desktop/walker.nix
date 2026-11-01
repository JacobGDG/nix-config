{
  persist = {
    users = {
      directories = [
        ".cache/elephant"
      ];
    };
  };

  flake.modules.homeManager.walker = {
    config,
    lib,
    pkgs,
    ...
  }: let
    toml = pkgs.formats.toml {};
    firefox = config.programs.firefox;

    # networkmanager_dmenu passes walker 0.x flags when the command is named "walker"
    nm-walker = pkgs.writeShellScript "nm-walker" ''
      exec walker --dmenu "$@"
    '';
  in {
    # elephant launches Terminal=true desktop entries through this
    home.packages = [pkgs.xdg-terminal-exec];

    services.elephant = {
      enable = true;

      # autodetection runs once at startup and falls back to a bare systemd-run
      # (no WAYLAND_DISPLAY) if uwsm isn't active yet, so apps silently fail
      settings.launch_prefix = "uwsm app --";

      # bookmarks provider imports from firefox via sqlite3, which isn't in the upstream wrapper
      package = pkgs.symlinkJoin {
        name = "elephant";
        paths = [pkgs.elephant];
        nativeBuildInputs = [pkgs.makeWrapper];
        postBuild = ''
          wrapProgram $out/bin/elephant --prefix PATH : ${lib.makeBinPath [pkgs.sqlite]}
        '';
        meta.mainProgram = "elephant";
      };
    };

    xdg.configFile = {
      "networkmanager-dmenu/config.ini".text = lib.generators.toINI {} {
        dmenu.dmenu_command = "${nm-walker}";
      };

      "elephant/websearch.toml".source = toml.generate "elephant-websearch" {
        # engines are fuzzy-matched by name and non-matches score 0, so keep
        # them all listed and treat the whole query as the search term
        min_score = -1;
        entries = [
          {
            name = "DuckDuckGo";
            default = true;
            url = "https://duckduckgo.com/?q=%TERM%";
          }
          {
            name = "NixPackages";
            url = "https://search.nixos.org/packages?channel=${lib.trivial.release}&query=%TERM%";
          }
        ];
      };

      "elephant/bookmarks.toml".source = toml.generate "elephant-bookmarks" {
        browsers = [
          {
            name = "Firefox";
            command = "uwsm app -- firefox";
          }
        ];
      };
    };

    # both only read their config once at startup, and elephant indexes desktop
    # entries once too, so restart them on switch when any of it changes
    systemd.user.services = let
      sources = prefix:
        lib.mapAttrsToList (_: f: "${f.source}")
        (lib.filterAttrs (n: _: lib.hasPrefix prefix n) config.xdg.configFile);
    in {
      elephant.Unit = {
        X-Restart-Triggers = ["${config.home.path}"] ++ sources "elephant/";
        After = ["graphical-session.target"];
        PartOf = ["graphical-session.target"];
      };
      # walker needs the wayland display, which uwsm exports before reaching this target
      walker.Unit = {
        X-Restart-Triggers = sources "walker/";
        After = ["graphical-session.target"];
        PartOf = ["graphical-session.target"];
      };
    };

    # elephant only discovers firefox profiles under ~/.mozilla, ours lives in XDG config
    home.file = lib.mkIf firefox.enable {
      ".mozilla/firefox/default/places.sqlite".source =
        config.lib.file.mkOutOfStoreSymlink "${firefox.configPath}/${firefox.profiles.default.path}/places.sqlite";
    };

    services.walker = {
      enable = true;
      systemd.enable = true; # keep a warm service so opening is instant

      settings = {
        as_window = true; # layer-shell follows you across workspaces, a window stays put
        close_when_open = true;
        selection_wrap = true;

        keybinds = {
          next = ["Down" "ctrl j"];
          previous = ["Up" "ctrl k"];
        };

        placeholders.default = {
          input = "Apps";
          list = "No Results";
        };
      };

      theme = {
        name = "nix";
        style = ''
          @define-color window_bg_color #${config.colorScheme.palette.base00};
          @define-color input_bg_color #${config.colorScheme.palette.base01};
          @define-color accent_bg_color #${config.colorScheme.palette.base0D};
          @define-color theme_fg_color #${config.colorScheme.palette.base05};
          @define-color error_bg_color #${config.colorScheme.palette.base08};

          * {
            all: unset;
            font-family: JetBrainsMono;
            font-size: 12px;
          }

          scrollbar {
            opacity: 0;
          }

          .normal-icons {
            -gtk-icon-size: 16px;
          }

          .large-icons {
            -gtk-icon-size: 32px;
          }

          popover {
            background: @window_bg_color;
            border-radius: 5px;
            padding: 10px;
          }

          .box-wrapper {
            background: @window_bg_color;
            color: @theme_fg_color;
            padding: 20px;
            border-radius: 5px;
          }

          .input {
            caret-color: @theme_fg_color;
            background: @input_bg_color;
            color: @theme_fg_color;
            padding: 8px 12px;
            border-radius: 5px;
          }

          .input placeholder {
            opacity: 0.5;
          }

          .scroll {
            margin-top: 20px;
          }

          .list,
          .preview-box,
          .elephant-hint,
          .placeholder {
            color: @theme_fg_color;
          }

          .item-box {
            padding: 6px;
            border-radius: 5px;
          }

          .item-image {
            padding-right: 8px;
          }

          .item-subtext {
            font-size: 10px;
            opacity: 0.5;
          }

          child:selected .item-box,
          row:selected .item-box {
            background: @accent_bg_color;
          }

          .item-quick-activation {
            opacity: 0.5;
          }

          .calc .item-text {
            font-size: 20px;
          }

          .keybinds {
            padding-top: 10px;
            border-top: 1px solid @input_bg_color;
            color: @theme_fg_color;
          }

          .keybind-bind {
            text-transform: lowercase;
            opacity: 0.35;
          }

          .keybind-label {
            padding: 2px 4px;
            border-radius: 5px;
            border: 1px solid @theme_fg_color;
          }

          .error {
            padding: 10px;
            background: @error_bg_color;
            color: @theme_fg_color;
          }
        '';
      };
    };
  };
}
