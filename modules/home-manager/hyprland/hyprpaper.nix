{
  pkgs,
  config,
  inputs,
  lib,
  ...
}: {
  home = {
    packages = with pkgs; [
      hyprpaper
    ];

    file."${config.xdg.configHome}/hypr/hyprpaper.conf" = {
      text = ''
        preload=${inputs.wallpapers}/nature/haystacks.jpg
        wallpaper=,${inputs.wallpapers}/nature/haystacks.jpg
      '';
    };
  };

  systemd.user.services = lib.mkForce {
    hyprpaper = {
      Install = {
        WantedBy = ["graphical-session.target"];
      };

      Unit = {
        Description = "Hyprpaper UWSM";
        Documentation = ["https://github.com/hyprwm/hyprpaper"];
        After = ["graphical-session.target"];
      };

      Service = {
        Type = "exec";
        ExecStart = "${pkgs.hyprpaper}/bin/hyprpaper";
        ExecCondition = "${pkgs.systemd}/lib/systemd/systemd-xdg-autostart-condition \"Hyprland\" \"\" ";
        Restart = "on-failure";
        Slice = "background-graphical.slice";
      };
    };
  };
}
