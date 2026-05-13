{jg, ...}: {
  jg.hyprland.includes = [jg.hyprpaper];

  # TODO: declare flake-file.inputs.wallpapers and use wallpaper path
  jg.hyprpaper.homeManager = {
    config,
    pkgs,
    lib,
    ...
  }: {
    home.packages = [pkgs.hyprpaper];

    # TODO: configure hyprpaper.conf once wallpaper input is available
    # home.file."${config.xdg.configHome}/hypr/hyprpaper.conf".text = ''
    #   preload=<wallpaper_path>
    #   wallpaper=,<wallpaper_path>
    # '';

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
