{
  flake.modules.homeManager.hyprpaper = {
    config,
    pkgs,
    lib,
    ...
  }: {
    home = {
      packages = [pkgs.hyprpaper];

      # Wallpaper config — update path before enabling
      # file."${config.xdg.configHome}/hypr/hyprpaper.conf".text = ''
      #   preload=/path/to/wallpaper.jpg
      #   wallpaper=,/path/to/wallpaper.jpg
      # '';
    };

    systemd.user.services = lib.mkForce {
      hyprpaper = {
        Install.WantedBy = ["graphical-session.target"];
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
  };
}
