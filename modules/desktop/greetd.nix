{
  persist = {
    directories = [
      "/var/cache/tuigreet"
    ];
  };

  flake.modules.nixos.greetd = {
    config,
    lib,
    pkgs,
    ...
  }: let
    sessions = "${config.services.displayManager.sessionData.desktops}/share/wayland-sessions";
  in {
    services.greetd = {
      enable = true;
      settings.default_session.command = lib.concatStringsSep " " [
        (lib.getExe pkgs.tuigreet)
        "--time"
        "--remember"
        "--remember-session"
        "--asterisks"
        "--sessions ${sessions}"
      ];
    };
  };
}
