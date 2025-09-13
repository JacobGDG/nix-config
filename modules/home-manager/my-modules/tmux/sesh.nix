{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.myModules.tmux.sesh;
in {
  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.sesh];

    xdg.configFile."sesh/sesh.toml".source = (pkgs.formats.toml {}).generate "sesh.toml" {
      default_session.startup_command = cfg.startup_command;
      session = cfg.sessions;
    };
  };
}
