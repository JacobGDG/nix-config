{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.myModules.tmux.sesh;
  sesh_open = pkgs.writeScriptBin "tmux-sesh-open" (builtins.readFile ./scripts/tmux-sesh-open.sh);
in {
  config = lib.mkIf cfg.enable {
    myModules.tmux.bindings.s = lib.mkDefault "run-shell tmux-sesh-open";

    home.packages = [
      pkgs.sesh
      sesh_open
    ];

    xdg.configFile."sesh/sesh.toml".source = (pkgs.formats.toml {}).generate "sesh.toml" {
      default_session.startup_command = cfg.startup_command;
      session = cfg.sessions;
    };
  };
}
