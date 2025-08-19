{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.myModules.mpv;
in {
  options = {
    myModules.mpv = {
      enable = lib.mkOption {
        default = false;
        description = ''
          whether to enable
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.mpv = {
      enable = true;
      package = (
        pkgs.mpv-unwrapped.wrapper {
          scripts = with pkgs.mpvScripts; [
            uosc
            sponsorblock
          ];

          mpv = pkgs.mpv-unwrapped.override {
            waylandSupport = true;
          };
        }
      );

      config = {
        profile = "high-quality";
        ytdl-format = "bestvideo+bestaudio";
        cache-default = 4000000;
      };
    };
  };
}
