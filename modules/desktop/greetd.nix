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
    # uwsm brings up graphical-session.target, which home-manager services depend on
    session = "${lib.getExe config.programs.uwsm.package} start -e -D Hyprland hyprland.desktop";
  in {
    services.greetd = {
      enable = true;
      settings.default_session.command = lib.concatStringsSep " " [
        (lib.getExe pkgs.tuigreet)
        "--time"
        "--remember"
        "--asterisks"
        "--cmd '${session}'"
      ];
    };
  };
}
