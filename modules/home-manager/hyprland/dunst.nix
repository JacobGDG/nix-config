{
  pkgs,
  config,
  ...
}: {
  home.packages = [
    pkgs.dunst # notification
  ];

  home.file."${config.xdg.configHome}/dunst/dunstrc" = {
    text = ''
      [global]
          font = "JetBrainsMono Nerd Font"
    '';
  };
}
