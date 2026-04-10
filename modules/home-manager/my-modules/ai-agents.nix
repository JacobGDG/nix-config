{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.myModules.aiAgents;
in {
  options = {
    myModules.aiAgents = {
      enable = lib.mkEnableOption "AI Agents";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      opencode
    ];

    programs.claude-code = {
      enable = true;
      settings = {
        theme = "dark";
      };
    };
  };
}
