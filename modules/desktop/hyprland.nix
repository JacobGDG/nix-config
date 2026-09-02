{
  flake.modules.nixos.hyprland = {
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };

    services.xserver.xkb.options = "caps:none";

    security.pam.services.hyprlock.enable = true;

    programs = {
      hyprlock.enable = true;

      hyprland = {
        enable = true;
        withUWSM = true;
      };
    };
  };

  flake.modules.homeManager.hyprland = {
    config,
    pkgs,
    inputs,
    ...
  }: {
    imports = [inputs.self.modules.homeManager.terminal];

    home.packages = with pkgs; [
      brightnessctl
      libnotify
      networkmanager
      networkmanager_dmenu
      pavucontrol
      pulseaudio
      kdePackages.dolphin
      hyprshutdown
      playerctl
      ungoogled-chromium
    ];

    home.pointerCursor = {
      gtk.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 14;
    };

    fonts.fontconfig.enable = true;

    xdg.configFile."hypr/config.lua".source = ./config/hypr/config.lua;

    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      configType = "lua";
      systemd = {
        enable = false;
        variables = ["--all"];
      };

      extraConfig = ''
        -- Variables
        app        = "uwsm app --"
        mod        = "SUPER"
        window_mod = mod .. " + CTRL"
        terminal   = app .. " kitty"
        browser    = app .. " firefox"
        webapp     = app .. " chromium --new-window --ozone-platform=wayland --app"
        launcher   = app .. " wofi --show drun"

        -- Colors (injected by Nix)
        active_border   = "rgb(${config.colorScheme.palette.base05})"
        inactive_border = "rgb(${config.colorScheme.palette.base02})"

        hl.config({
          input =  {
            kb_layout = "gb";
            kb_options = "ctrl:nocaps";
            repeat_delay = 200;
            repeat_rate = 40;
          }
        })

        require("config")
      '';
    };
  };
}
