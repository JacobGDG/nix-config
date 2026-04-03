{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.myModules.nixUpdateApp;
  nix_update = pkgs.writeShellApplication {
    name = "nix-update";

    runtimeInputs = with pkgs; [
      just
      git
    ];

    text = ''
      trap "read -p 'Press [ENTER] to continue...'" ERR

      cd ${cfg.configPath} || exit 1

      just full_sync
    '';
  };
in {
  options.myModules.nixUpdateApp = {
    enable = lib.mkEnableOption "updateApplication";
    configPath = lib.mkOption {
      type = lib.types.str;
      default = "${config.home.homeDirectory}/src/nix-config";
      description = "Path to config file for update-application";
    };
  };

  config = lib.mkIf cfg.enable {
    xdg.desktopEntries = {
      update = {
        name = "Nix Update";
        genericName = "Nix Update";
        comment = "Run update nix system";
        exec = "${nix_update}/bin/nix-update";
        terminal = true;
      };
    };
  };
}
