{
  flake.modules.nixos.hyprland = {
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };

    security.pam.services.hyprlock.enable = true;

    programs = {
      hyprlock.enable = true;

      uwsm = {
        enable = true;
        waylandCompositors.hyprland = {
          prettyName = "Hyprland";
          comment = "Hyprland compositor managed by UWSM";
          binPath = "/run/current-system/sw/bin/Hyprland";
        };
      };

      hyprland = {
        enable = true;
        withUWSM = true;
      };
    };
  };

  flake.modules.homeManager.hyprland = {inputs, ...}: {
    imports = [inputs.self.modules.homeManager.terminal];
    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      systemd = {
        # disable systemd integration as it conflicts with uwsm
        enable = false;
        variables = ["--all"];
      };
    };
  };
}
