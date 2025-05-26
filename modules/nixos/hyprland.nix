{
  inputs,
  pkgs,
  hostConfig,
  ...
}: {
  # services.displayManager.sddm.enable = true;
  # services.displayManager.sddm.wayland.enable = true;
  # ly
  services.displayManager = {
    sddm = {
      enable = true;
      wayland = {
        enable = true;
      };
    };
  };

  # Allow hyprlock to perform auth
  security.pam.services.hyprlock = {};

  programs = {
    hyprlock.enable = true;

    uwsm = {
      enable = true;
      waylandCompositors = {
        hyprland = {
          prettyName = "Hyprland";
          comment = "Hyprland compositor managed by UWSM";
          binPath = "/run/current-system/sw/bin/Hyprland";
        };
      };
    };

    hyprland = {
      enable = true;
      withUWSM = true;
    };
  };
}
