{
  mylib,
  lib,
  ...
}: {
  options = {
    myModules.tmux = {
      enable = lib.mkEnableOption "tmux";
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

  imports = mylib.scanPaths ./.;
}
