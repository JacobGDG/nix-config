{
  inputs,
  jg,
  ...
}: {
  flake-file.inputs.wallpapers = {
    url = "git+ssh://git@github.com/JacobGDG/wallpapers.git?shallow=1";
    flake = false;
  };

  jg.hyprland.includes = [jg.hyprpaper];

  jg.hyprpaper.homeManager = {
    config,
    pkgs,
    lib,
    ...
  }: {
    home.packages = [pkgs.hyprpaper];

    xdg.configFile."hypr/hyprpaper.conf".text = ''
      preload="${inputs.wallpapers}/nature/haystacks.jpg";
      wallpaper=,"${inputs.wallpapers}/nature/haystacks.jpg";
    '';

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
