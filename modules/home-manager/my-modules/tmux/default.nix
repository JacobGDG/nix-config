{
  mylib,
  lib,
  pkgs,
  ...
}: {
  options = {
    myModules.tmux = {
      enable = lib.mkEnableOption "tmux";
      bindings = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        description = "An attribute set with arbitrary keys and string values.";
      };
      shell = lib.mkOption {
        type = lib.types.str;
        default = "${pkgs.zsh}/bin/zsh";
        description = "Preferred shell";
      };
      sesh = {
        enable = lib.mkEnableOption "sesh";
        startup_command = lib.mkOption {
          type = lib.types.str;
          description = "Default startup command for new sessions";
        };
        sessions = lib.mkOption {
          type = lib.types.listOf (lib.types.submodule {
            options = {
              name = lib.mkOption {
                type = lib.types.str;
                description = "Name of the session";
              };
              path = lib.mkOption {
                type = lib.types.str;
                default = "";
                description = "Path to open the session in";
              };
              startup_command = lib.mkOption {
                type = lib.types.str;
                description = "Command to run on startup";
              };
            };
          });
          default = [];
          description = "List of sesh sessions to create";
        };
      };
      tmuxifier.enable = lib.mkEnableOption "tmuxifier";
    };
  };

  config.myModules.tmux.bindings = {
    o = lib.mkDefault "run-shell open-last-url";
    g = lib.mkDefault "split-window -h -c \"#{pane_current_path}\"";
    h = lib.mkDefault "split-window -c \"#{pane_current_path}\"";
    r = lib.mkDefault "source ~/.config/tmux/tmux.conf";
  };

  imports = mylib.scanPaths ./.;
}
